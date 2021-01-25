import { LitElement, html, css } from '../node_modules/lit-element/lit-element';
export class userelement extends LitElement {
  // Declaration of property
  static get properties() {
    return {
      users: { type: Array },
    };
  }

  // Constructor with initialization of the property
  constructor() {
    super();
    this.users = [];
    this.message = ' ';
    this.getUsers().then((users) => (this.users = users));
  }

  static styles = css`
    :host {
      display: block;
    }

    .outer-container {
      background-color: #9e83aa;
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      margin: 0;
    }

    .container {
      background-color: #ffffff;
      border-radius: 5px;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
      overflow: hidden;
      width: 450px;
      max-width: 100%;
      max-height: 100%;
    }

    h1 {
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px 30px;
    }

    .form-group {
      padding: 10px 30px;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .form-group2 {
      /* For user-info*/
      padding: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .form-group label {
      display: inline-block;
      margin-bottom: 5px;
      padding: 20px 30px;
    }
    .form-text {
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .button {
      background-color: #734e83;
      border: 2px solid #734e83;
      border-radius: 5px;
      color: #fff;
      display: block;
      padding: 10px;
      margin-top: 10px;
      width: 75%;
      display: flex;
      align-items: center;
      justify-content: center;
    }
  `;


  render() {
    return html`

      <head>
        <!-- Required meta tags -->
        <meta charset="utf-8" />
        <meta
          name="viewport"
          content="width=device-width, initial-scale=1, shrink-to-fit=no"
        />

        <!-- Bootstrap CSS -->
        <link
          rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css"
          integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2"
          crossorigin="anonymous"
        />
      </head>
      <body>
      <nav class="navbar navbar-expand-sm navbar-light bg-light">
          <a class="navbar-brand" href="/">Forum</a>
          <a class="navbar-brand" href="/login">Login</a>
          <a class="navbar-brand" href="/registerUser">Register</a>
          <a class="navbar-brand" href="/getUsers">Users</a>
        </nav>

        <div style="display: block">
          ${this.users.map((user) => {
            return this.renderUsers(user);
          })}
        </div>
        <!-- Option 1: jQuery and Bootstrap Bundle (includes Popper) -->
        <script
          src="https://code.jquery.com/jquery-3.5.1.slim.min.js"
          integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
          crossorigin="anonymous"
        ></script>
        <script
          src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js"
          integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx"
          crossorigin="anonymous"
        ></script>
      </body>
    `;
  }

  renderUsers(user) {
    const avatar =
      user.avatar || 'https://static.thenounproject.com/png/642902-200.png';
    const { uid, email } = user;

    return html`<div
      key="${uid}"
      style="form-group"
    >
      <div style="form-group2">
        <div style="form-group">
          <img
            src=${avatar}
            alt="Avatar"
            style="max-width: 50px; margin-bottom: 5px"
          />
          <p>User nr. ${uid}</p>
          <p style="form-group">
            ${email}
          </p>
        </div>
      </div>
    </div>`;
  }

  getUsers() {
    return fetch(`${window.MyAppGlobals.serverURL}getUsers`, {
      method: 'GET',
      credentials: 'include',
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
      },
    }).then((res) => res.json());
  } 
}
customElements.define('user-element', userelement);
