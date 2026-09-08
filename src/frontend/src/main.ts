import { bootstrapApplication } from '@angular/platform-browser';
import { Component } from '@angular/core';

@Component({
  selector: 'knowledge-root',
  standalone: true,
  template: `
    <main class="app">
      <h1>Knowledge</h1>
      <p>Knowledge platform is starting.</p>
    </main>
  `
})
class AppComponent {}

bootstrapApplication(AppComponent).catch((error) => console.error(error));
