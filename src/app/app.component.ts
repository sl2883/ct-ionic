import { Component, OnInit} from '@angular/core';
import { CleverTap } from '@ionic-native/clevertap/ngx';
import { Platform } from '@ionic/angular';
import {
  ActionPerformed,
  PushNotificationSchema,
  PushNotifications,
  Token,
} from '@capacitor/push-notifications';

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
  styleUrls: ['app.component.scss'],
  providers:[Platform, CleverTap]
})
export class AppComponent implements OnInit {
  ngOnInit() {
    PushNotifications.requestPermissions().then(result => {
      if (result.receive === 'granted') {
        // Register with Apple / Google to receive push via APNS/FCM
        PushNotifications.register();
      } else {
        // Show some error
      }
    });
  }

  constructor(platform: Platform, clevertap: CleverTap) {
    platform.ready().then(() => {
      console.log("I'm here in App Component")
      

      document.addEventListener('onDeepLink', (e: any) => {
        console.log('Clevertap onDeepLink in App component');
        console.log(e.deeplink);

        alert('Clevertap onDeepLink in App component' + e.deeplink);
      });

      document.addEventListener('onPushNotification', (e: any) => {
        console.log('onPushNotification');
        console.log(JSON.stringify(e.notification));
      });

      clevertap.setDebugLevel(3);
      clevertap.enablePersonalization();

    });
  }
}
