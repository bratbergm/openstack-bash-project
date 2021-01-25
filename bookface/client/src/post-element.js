import { LitElement, html, css } from '../node_modules/lit-element/lit-element';
export class postelement extends LitElement {
  // Declaration of property
  static get properties() {
    return {
      message: { type: String },
      title: { type: String },
      content: { type: String },
      posts: { type: Array },
    };
  }

  // Constructor with initialization of the property
  constructor() {
    super();
    this.posts = [];
    this.message = ' ';
    this.getPosts().then((posts) => (this.posts = posts));
  }

  static styles = css`
    :host {
      display: block;
    }

    .container-outer {
      background-color: rgb(194, 25, 25);
    }

    .form-group {
      padding: 10px 30px;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .button {
      background-color: #008cba;
      border: none;
      color: white;
      padding: 16px 32px;
      text-decoration: none;
      margin: 4px 2px;
      cursor: pointer;
    }
  `;

  render() {
    return html`
    <!--
      <script>
        fetch('localhost:8081/getPosts')
          .then(function (response) {
            return response.json();
          })
          .then(function (data) {
            appendData(data);
          })
          .catch(function (err) {
            console.log('error: ' + err);
          });
      </script>
-->
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
          ${this.posts.map((post) => {
            return this.renderPost(post);
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

  renderPost(post) {
    const avatar =
      post.avatar || 'https://static.thenounproject.com/png/642902-200.png';
    const { postId, userId, title, content, userType, email } = post;

    return html`<div
      key="${postId}"
      style="border-bottom: 1px solid #eee; padding: 15px"
    >
      <div style="display: table-cell; vertical-align: top">
        <div style="display: block; min-width: 100px">
          <img
            src=${avatar}
            alt="Avatar"
            style="max-width: 50px; margin-bottom: 5px"
          />
          <p>${userType} #${userId}</p>
          <p
            style="max-width: 100px; overflow: hidden; text-overflow: ellipsis"
          >
            ${email}
          </p>
        </div>
      </div>
      <div style="display: table-cell; vertical-align: top">
        <h4 style="margin-top: 0; margin-bottom: 5px">${title}</h4>
        <div>${content}</div>
      </div>
    </div>`;
  }

  getPosts() {
    return fetch(`${window.MyAppGlobals.serverURL}getPosts`, {
      method: 'GET',
      credentials: 'include',
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
      },
    }).then((res) => res.json());
  } 
}
customElements.define('post-element', postelement);
