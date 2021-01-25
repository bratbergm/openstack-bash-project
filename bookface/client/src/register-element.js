import { LitElement, html, css } from '../node_modules/lit-element/lit-element';

export class RegisterELement extends LitElement {
  // Declaration of property
  static get properties() {
    return {
      message: { type: String },
      email: { type: String },
      password: { type: String },
      passwordConfirm: { type: String },
    };
  }

  // Constructor with initialization of the property
  constructor() {
    super();
    this.message = ' ';
    this.email = '';
    this.password = '';
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
      width: 550px;
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
      /* For "help-text" */
      padding: 1px 20px 30px 10px;
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

        <div class="outer-container">
          <div class="container">
            <form onsubmit="javascript: return false; ">
              <h1>Create New Account</h1>

              <div class="form-group">
                <label for="email">Email address</label>
                <input
                  type="email"
                  name="email"
                  class="form-control"
                  id="email"
                  placeholder="your@email.com"
                />
              </div>

              <div class="form-group">
                <label for="password">Password</label>
                <input
                  type="password"
                  name="password"
                  class="form-control"
                  id="password"
                  placeholder="Your password"
                />
              </div>

              <div class="form-group">
                <label for="passwordConfirm">Confirm Password</label>
                <input
                  type="password"
                  name="passwordConfirm"
                  class="form-control"
                  id="passwordConfirm"
                  placeholder="Your password"
                />
              </div>

              <div class="form-group">
                <button
                  type="button"
                  class="button"
                  @click=${this.registerUser}
                >
                  Submit
                </button>
              </div>

              <div class="form-group">
                <a class="button" href="/login">Login</a>
              </div>

              <div class="form-group2">
                <small class="form-text text-muted"
                  >Already have an account? Click to login</small
                >
              </div>
            </form>

            ${this.message ? html`<p>${this.message}</p>` : hmtl``}
          </div>
        </div>
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

  registerUser(e) {
    console.log(e.target);

    const data = new FormData(e.target.form);
    var object = {};
    data.forEach((value, key) => (object[key] = value));
    const jasonData = JSON.stringify(object);

    fetch(`${window.MyAppGlobals.serverURL}registerUser`, {
      method: 'POST',
      credentials: 'include',
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
      },
      body: jasonData,
    }).then((res) => {
      console.log(res);
      if (res.status == 200) {
        // If sucsessful register
        console.log('User registered');
        window.location.href = '/login';
      } else if (res.status == 450) {
        // If one or more input fields are empty
        if (!alert('Please provide all inputs')) {
          window.location.reload();
        }
      } else if (res.status == 400) {
        // If the email already exists in database
        console.log('Email is in use');
        // alert-box, reloads page when user click 'OK'
        if (!alert('The email is already in use')) {
          window.location.reload();
        }
      } else if (res.status == 300) {
        // If password input mismatch
        if (!alert('The passwords do not match')) {
          window.location.reload();
        }
      }
    });
    /*
        ).then(data => {
            console.log(data);
            this.message = data['message'];
        })
        .then(function(response) {
            return response.text();
        })
*/
  }
}
customElements.define('register-element', RegisterELement);
