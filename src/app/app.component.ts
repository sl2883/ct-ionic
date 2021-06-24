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
  

  constructor(platform: Platform, private clevertap: CleverTap) {
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

  ngOnInit() {
    this.clevertap.registerPush();

    // document.addEventListener('onDeepLink', (e: any) => {
    //   console.log('Clevertap onDeepLink');
    //   console.log(e.deeplink);

    //   alert('Clevertap onDeepLink' + e.deeplink);
    // });

    // document.addEventListener('onPushNotification', (e: any) => {
    //   console.log('onPushNotification');
    //   console.log(JSON.stringify(e.notification));
    // });

    // // On success, we should be able to receive notifications
    // PushNotifications.addListener('registration',
    //   (token: Token) => {
    //     alert('Push registration success, token: ' + token.value);
    //     //this.clevertap.setPushToken(token.value)
    //   }
    // );

    // // Some issue with our setup and push will not work
    // PushNotifications.addListener('registrationError',
    //   (error: any) => {
    //     alert('Error on registration: ' + JSON.stringify(error));
    //   }
    // );

    // Show us the notification payload if the app is open on our device
    PushNotifications.addListener('pushNotificationReceived',
      (notification: PushNotificationSchema) => {
        alert('Push received: ' + JSON.stringify(notification));
      }
    );

    // Method called when tapping on a notification
    PushNotifications.addListener('pushNotificationActionPerformed',
      (notification: ActionPerformed) => {
        alert('Push action performed: ' + JSON.stringify(notification));
      }
    );
  }
}
