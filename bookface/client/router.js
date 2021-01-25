import { Router } from '@vaadin/router';
import './src/hp-element.js';
import './src/ap-element.js';
import './src/register-element.js';
import './src/login-element.js';
import './src/post-element.js';

const router = new Router(document.getElementById('outlet'));
router.setRoutes([
  { path: '/', component: 'hp-element' },
  { path: '/registerUser', component: 'register-element' },
  { path: '/login', component: 'login-element' },
  { path: '/post', component: 'post-element' },
  { path: '/addPost', component: 'ap-element' },
]);
