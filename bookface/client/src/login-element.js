import { LitElement, html, css } from '../node_modules/lit-element/lit-element';

export class LoginELement extends LitElement {
  // Declaration of property
  static get properties() {
    return {
      message: { type: String },
      email: { type: String },
      password: { type: String },
    };
  }

  // Constructor with initialization of the property
  constructor() {
    super();
    this.message = 'TEST '; // Skal det stå noe her? Siden feiler hvis ikke
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
      width: 400px;
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
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

                <!-- Bootstrap CSS -->
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">
            </head>

        <body>
        <nav class="navbar navbar-expand-sm navbar-light bg-light">
            <a class="navbar-brand" href="/">Forum</a>
            <a class="navbar-brand" href="/login">Login</a>
            <a class="navbar-brand" href="/registerUser">Register</a>
        </nav>

        <div class="outer-container d-flex flex-row">
            <div class="container">
                <div>
                    <h1>Login</h1>
                </div>
                <form onsubmit="javascript: return false;">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="email">Email address</label>
                            <input type="email" class="form-control" name="email" id="email" placeholder="your@email.com">
                        </div>
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" class="form-control" name="password" id="password" placeholder="Your password">
                        </div>
                    </div>
                    <div class="form-group">
                        <input type="submit"  class="button" value="Login" @click=${
                          this.loginUser
                        }>
                    </div>
                        <div class="form-group">
                            <a class="button" href="/registerUser">Register</a>
                        </div>
                        <div class="form-group2">
                            <small class="form-text text-muted">Don't have an account? Click to register</small>
                        </div>
                        ${this.message ? html`<p>${this.message}</p>` : hmtl``}
                    </div>
                </form>
            </div>
        </div>



        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>


    </body>
        `;
  }

  loginUser(e) {
    console.log(e.target);

    const data = new FormData(e.target.form);
    var object = {};
    data.forEach((value, key) => (object[key] = value));
    const jasonData = JSON.stringify(object);

    fetch(`${window.MyAppGlobals.serverURL}loginUser`, {
      method: 'POST',
      credentials: 'include',
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
      },
      body: jasonData,
    }).then((res) => {
      console.log(res);
      if (res.status == 400) {
        if (!alert('Please provide inputs')) {
          window.location.reload();
        }
      } else if (res.status == 300) {
        if (!alert('Email is wrong')) {
          window.location.reload();
        }
      } else if (res.status == 450) {
        if (!alert('Password is wrong')) {
          window.location.reload();
        }
      } // If login OK, goes to forum start page
      else if (res.status == 200) {
        window.location.href = '/';
      }
    });
  }

  // Forslag: Hvis vi får til å vise posts; bruk '/' som "åpen" side der man kan se,
  // men ikke lage nye posts.
  // Lag en ny side '/forum' som man kommer til etter inlogging der man kan adde posts.
}
customElements.define('login-element', LoginELement);
