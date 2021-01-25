import { LitElement, html, css } from '../node_modules/lit-element/lit-element';

export class apelement extends LitElement {
  // Declaration of property
  static get properties() {
    return {
      message: { type: String },
      content: { type: String },
      title: { type: String },
      user: { type: Number },
    };
  }

  // Constructor with initialization of the property
  constructor() {
    super();
    this.message = 'TEST '; // Skal det stå noe her? Siden feiler hvis ikke
    this.title = '';
    this.content = '';
  }

  static styles = css`
    :host {
      display: block;
    }

    .container-outer {
      background-color: rgb(194, 25, 25);
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
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">

    <title>Post</title>
  </head>
  <body>

    <nav class="navbar navbar-expand-sm navbar-light bg-light">
      <a class="navbar-brand" href="/">Forum</a>
      <a class="navbar-brand" href="/login">Login</a>
      <a class="navbar-brand" href="/registerUser">Register</a>
    </nav>

    <div class="container md-6">

        <div class="form-group">
            <h3>Add a post</h3>
        </div>

        <form method='POST'>
            <div class="form-row">

                <div class="form-group">
                    <label for="title">Title</label>
                    <input type="text" id="title" name="title" class="form-control"  placeholder="Title">
                </div>

            </div>

            <div class="form-group">
                <label for="content">Content</label>
                <textarea class="form-control" id="content" name="content" rows="3" placeholder="Write your post here"></textarea>
            </div>

            <div class="form-group">
                <label for="content">Nr</label>
                <input type="number" class="form-control" id="user" name="user" rows="3" placeholder="user NR">
            </div>

            <div class="form-group">
                <button type="button" class="button" @click=${this.addPost}>Submit</button>
            </div>

            </div>
        </form>

    </div>

    <!-- Option 1: jQuery and Bootstrap Bundle (includes Popper) -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>


  </body>
        `;
  }

  addPost(e) {
    console.log(e.target);

    const data = new FormData(e.target.form);
    var object = {};
    data.forEach((value, key) => (object[key] = value));
    const jasonData = JSON.stringify(object);

    fetch(`${window.MyAppGlobals.serverURL}addPost`, {
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
        console.log('Post added');
        if (!alert('Post is added')) {
          window.location.reload();
        }
      } else if (res.status == 400) {
        if (!alert('Please fill in all fields')) {
          window.location.reload();
        }
      }
    });
  }
}
customElements.define('ap-element', apelement);
