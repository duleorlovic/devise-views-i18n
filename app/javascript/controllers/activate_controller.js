import { Controller } from 'stimulus'

export default class extends Controller {
  add() {
    let selector = this.data.get('selector')
    let elements = document.querySelectorAll(selector)
    for (let element of elements) {
      element.classList.add('active')
    }
    console.log(`activate add ${selector}`)
  }

  // <div class='sidebar__overlay' data-controller='activate' data-action='click->activate#toggle' data-activate-selector='#sidebar,.sidebar__overlay'></div>
  // <%= button_tag class: "btn btn-link", 'data-controller': 'activate', 'data-action': 'activate#toggle', 'data-activate-selector': '#sidebar,.sidebar__overlay' do %>
  toggle() {
    let selector = this.data.get('selector')
    let elements = document.querySelectorAll(selector)
    for (let element of elements) {
      element.classList.toggle('active')
    }
    console.log(`activate toggle ${selector}`)
  }

  toggleForValueIncludes() {
    let selector = this.data.get('selector')
    let elements = document.querySelectorAll(selector)
    let value = this.element.value
    for (let element of elements) {
      // instead of element.dataset('activateTarget) we can use
      // element.getAttribute('data-activate-target')
      if (element.getAttribute(selector.slice(1, -1)) && element.getAttribute(selector.slice(1, -1)).includes(value)) {
        element.classList.add('active')
      } else {
        element.classList.remove('active')
      }
    }
    console.log(`activate toggleForValueIncludes ${selector}`)
  }
}
