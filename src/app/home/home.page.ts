import { Component, OnInit } from '@angular/core';
import { CleverTap } from '@ionic-native/clevertap/ngx';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
  providers:[CleverTap]
})
export class HomePage implements OnInit {

  constructor(private clevertap: CleverTap) { 
  }

  ngOnInit() {
      console.log('Initializing HomePage');
  }
}
