import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['container']
  static values = { options: Object }

  static sourceUrl = 'https://challenges.cloudflare.com/turnstile/v0/api.js'
  static callbackFunctionName = '__turnstileLoadedCallback'

  // Shared across all instances so that multiple widgets on the same page
  // only ever inject one script tag and all resolve together.
  static loadingState = typeof window.turnstile !== 'undefined' ? 'ready' : 'unloaded'
  static pendingResolvers = []
  static pendingRejectors = []

  widgetId = undefined

  connect () {
    if (!this.hasOptionsValue) return

    // This call waits for the promise returned by loadTurnstile to resolve
    // before trying to call render().
    this.constructor.loadTurnstile()
      .then(() => { this.render() })
      .catch((e) => console.log(e))
  }

  disconnect () {
    if (this.widgetId !== undefined) {
      window.turnstile.remove(this.widgetId)
      this.widgetId = undefined
    }
  }

  render () {
    if (this.widgetId !== undefined) return

    // See https://developers.cloudflare.com/turnstile/get-started/client-side-rendering/widget-configurations/
    // render() returns a widget ID used for reset(), remove(), execute(), and getResponse().
    this.widgetId = window.turnstile.render(this.containerTarget, this.optionsValue)
  }

  // Static so that all instances share a single script load. Returns a promise
  // that resolves when Turnstile is ready, or rejects if the script fails to load.
  static loadTurnstile () {
    if (this.loadingState === 'ready') {
      return Promise.resolve()
    }

    if (this.loadingState === 'unloaded') {
      this.loadingState = 'loading'

      // This defines a global function that Turnstile calls once it is ready.
      // The name is embedded in the script URL via the onload parameter.
      // See https://developers.cloudflare.com/turnstile/get-started/client-side-rendering/#explicitly-render-the-turnstile-widget
      window[this.callbackFunctionName] = () => {
        this.loadingState = 'ready'
        delete window[this.callbackFunctionName]
        this.pendingResolvers.splice(0).forEach(resolve => resolve())
        this.pendingRejectors.splice(0)
      }

      const url = `${this.sourceUrl}?onload=${this.callbackFunctionName}&render=explicit`
      const script = document.createElement('script')
      script.src = url
      script.async = true
      script.defer = true

      script.addEventListener('error', () => {
        this.loadingState = 'unloaded'
        delete window[this.callbackFunctionName]
        this.pendingRejectors.splice(0).forEach(reject => reject('Failed to load Turnstile.'))
        this.pendingResolvers.splice(0)
      })

      document.head.appendChild(script)
    }

    // Loading is already in progress — queue this caller alongside any others.
    return new Promise((resolve, reject) => {
      this.pendingResolvers.push(resolve)
      this.pendingRejectors.push(reject)
    })
  }
}
