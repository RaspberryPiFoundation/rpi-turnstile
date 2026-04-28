import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['container']
  static values = { options: Object }

  static sourceUrl = 'https://challenges.cloudflare.com/turnstile/v0/api.js'
  static callbackFunctionName = '__turnstileLoadedCallback'

  loadingState = undefined
  loadingPromise = {
    resolve: () => {},
    reject: () => {}
  }
  widgetId = undefined

  initialize () {
    this.loadingState = typeof window.turnstile !== 'undefined' ? 'ready' : 'unloaded'

    // This defines a global function that can be called by Turnstile once it
    // has been loaded and ready.  The callbackFunctionName name is used in the
    // URL of the script in the loadTurnstile() function.
    window[this.constructor.callbackFunctionName] = () => {
      this.loadingPromise.resolve()
      this.loadingState = 'ready'
      delete window[this.constructor.callbackFunctionName]
    }
  }

  connect () {
    if (!this.hasOptionsValue) return

    // This call waits for the promise returned by loadTurnstile to resolve
    // before trying to call render().
    this.loadTurnstile()
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

  // This returns a promise that resolves when the loading has completed, or
  // rejects if an error is raised during loading.
  loadTurnstile () {
    if (this.loadingState === 'unloaded') {
      this.loadingState = 'loading'

      // See https://developers.cloudflare.com/turnstile/get-started/client-side-rendering/#explicitly-render-the-turnstile-widget
      const url = `${this.constructor.sourceUrl}?onload=${this.constructor.callbackFunctionName}&render=explicit`
      const script = document.createElement('script')
      script.src = url
      script.async = true
      script.defer = true

      script.addEventListener('error', () => {
        this.loadingPromise.reject('Failed to load Turnstile.')
        delete window[this.constructor.callbackFunctionName]
      })

      document.head.appendChild(script)
    }

    // Return a promise that we can resolve when the callback function is
    // called by the Turnstile JS when it is ready.
    return new Promise((resolve, reject) => {
      this.loadingPromise = { resolve, reject }

      // If turnstile is already defined, resolve immediately.
      if (this.loadingState === 'ready') {
        resolve()
        delete window[this.constructor.callbackFunctionName]
      }
    })
  }
}
