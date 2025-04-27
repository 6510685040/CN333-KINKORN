/*
const {onDocumentUpdated} = require('firebase-functions/v2/firestore');
const admin = require('firebase-admin');
admin.initializeApp();


exports.notifyOrderStatusChange = onDocumentUpdated('orders/{orderId}', async (event) => {
  const beforeData = event.data.before.data();
  const afterData = event.data.after.data();
  
  const beforeStatus = beforeData.orderStatus;
  const afterStatus = afterData.orderStatus;

  console.log('Before Status:', beforeStatus);
  console.log('After Status:', afterStatus);
  
  if (beforeStatus === afterStatus) {
    console.log('No status change, no notification.');
    return null;
  }
  
  const orderId = event.params.orderId;
  const customerId = afterData.customerId;
  const restaurantId = afterData.restaurantId;
  
  const customerDoc = await admin.firestore().collection('users').doc(customerId).get();
  const fcmToken = customerDoc.data()?.fcmToken;

  const restaurantDoc = await admin.firestore().collection('users').doc(restaurantId).get();
  const restaurantFcmToken = restaurantDoc.data()?.fcmToken;

  const notifications = [];
  
  if (!fcmToken) {
    console.log('No FCM Token found for customer:', customerId);
    return null;
  }

  // Notify Customer
  if (customerFcmToken) {
    const customerMessage = {
      token: customerFcmToken,
      notification: {
        title: 'Order Update!',
        body: `Your order status changed to ${afterStatus}`,
      },
      data: {
        orderId: orderId,
      },
    };
    notifications.push(admin.messaging().send(customerMessage));
    console.log('Queued notification for customer:', customerId);
  } else {
    console.log('No FCM token for customer:', customerId);
  }

  // Notify Restaurant
  if (restaurantFcmToken) {
    const restaurantMessage = {
      token: restaurantFcmToken,
      notification: {
        title: 'Order Update!',
        body: `Order ${orderId} status changed to ${afterStatus}`,
      },
      data: {
        orderId: orderId,
      },
    };
    notifications.push(admin.messaging().send(restaurantMessage));
    console.log('Queued notification for restaurant:', restaurantId);
  } else {
    console.log('No FCM token for restaurant:', restaurantId);
  }

  // Wait for all notifications
  try {
    await Promise.all(notifications);
    console.log('All notifications sent successfully.');
  } catch (error) {
    console.error('Error sending some notifications:', error);
  }

  return null;
  
  /*
  // Send notification
  const message = {
    token: fcmToken,
    notification: {
      title: 'Order Update!',
      body: `Your order is now ${afterStatus}`,
    },
    data: {
      orderId: event.params.orderId, // Pass order ID for deep linking
    },
  };
  
  try {
    await admin.messaging().send(message);
    console.log('Notification sent to', customerId);
  } catch (error) {
    console.error('Error sending notification:', error);
  }
  
  return null;
  
});*/

const { onDocumentUpdated } = require('firebase-functions/v2/firestore');
const admin = require('firebase-admin');
admin.initializeApp();

exports.notifyOrderStatusChange = onDocumentUpdated('orders/{orderId}', async (event) => {
  const beforeData = event.data.before.data();
  const afterData = event.data.after.data();

  const beforeStatus = beforeData.orderStatus;
  const afterStatus = afterData.orderStatus;

  console.log('Before Status:', beforeStatus);
  console.log('After Status:', afterStatus);

  if (beforeStatus === afterStatus) {
    console.log('No status change, no notification.');
    return null;
  }

  const customerId = afterData.customerId;

  // ----------------------
  // ส่ง Notification ให้ Customer
  // ----------------------
  const customerDoc = await admin.firestore().collection('users').doc(customerId).get();
  const customerFcmToken = customerDoc.data()?.fcmToken;

  if (customerFcmToken) {
    const customerMessage = {
      token: customerFcmToken,
      notification: {
        title: 'Order Update!',
        body: `Your order status is now ${afterStatus}`,
      },
      data: {
        orderId: event.params.orderId,
      },
    };

    try {
      await admin.messaging().send(customerMessage);
      console.log('Notification sent to customer', customerId);
    } catch (error) {
      console.error('Error sending notification to customer:', error);
    }
  } else {
    console.log('No FCM token found for customer:', customerId);
  }

  // ----------------------
  // ส่ง Notification ให้ Restaurant
  // ----------------------
  const ordersArray = afterData.orders;
  if (ordersArray && ordersArray.length > 0) {
    const restaurantId = ordersArray[0].restaurantId; // เอา restaurantId ตัวแรก
    console.log('Restaurant ID:', restaurantId);

    if (restaurantId) {
      const restaurantDoc = await admin.firestore().collection('users').doc(restaurantId).get();
      const restaurantFcmToken = restaurantDoc.data()?.fcmToken;

      if (restaurantFcmToken) {
        const restaurantMessage = {
          token: restaurantFcmToken,
          notification: {
            title: 'Order Status Changed!',
            body: `An order has been updated to ${afterStatus}`,
          },
          data: {
            orderId: event.params.orderId,
          },
        };

        try {
          await admin.messaging().send(restaurantMessage);
          console.log('Notification sent to restaurant', restaurantId);
        } catch (error) {
          console.error('Error sending notification to restaurant:', error);
        }
      } else {
        console.log('No FCM token found for restaurant:', restaurantId);
      }
    } else {
      console.log('No restaurantId found in orders array.');
    }
  } else {
    console.log('No orders array found in order document.');
  }

  return null;
});


/*

const {onDocumentCreated} = require('firebase-functions/v2/firestore');
//const admin = require('firebase-admin');
//admin.initializeApp();

exports.notifyRestaurantNewOrder = onDocumentCreated('orders/{orderId}', async (event) => {
  const orderData = event.data.data();
  const restaurantId = orderData.restaurantId;
  const customerId = orderData.customerId;

  // 1. Get restaurant's FCM token
  const restaurantDoc = await admin.firestore().collection('users').doc(restaurantId).get();
  const restaurantFcmToken = restaurantDoc.data()?.fcmToken;

  if (!restaurantFcmToken) {
    console.log('No FCM Token found for restaurant:', restaurantId);
    return null;
  }

  // 2. Get customer's name
  const customerDoc = await admin.firestore().collection('users').doc(customerId).get();
  const customerName = customerDoc.data()?.firstName || 'Customer';

  // 3. Send notification
  const message = {
    token: restaurantFcmToken,
    notification: {
      title: 'New Order Received!',
      body: `${customerName} just placed a new order!`,
    },
    data: {
      orderId: event.params.orderId, // optional: if you want deep linking
    },
  };

  try {
    await admin.messaging().send(message);
    console.log('Notification sent to restaurant:', restaurantId);
  } catch (error) {
    console.error('Error sending notification to restaurant:', error);
  }

  return null;
});
*/

const { onDocumentCreated } = require('firebase-functions/v2/firestore');
//const admin = require('firebase-admin');
//admin.initializeApp();

exports.notifyRestaurantNewOrder = onDocumentCreated('orders/{orderId}', async (event) => {
  const orderData = event.data.data(); // ข้อมูลออเดอร์ที่ถูกสร้างใหม่

  const ordersArray = orderData.orders;
  
  if (!ordersArray || ordersArray.length === 0) {
    console.log('No orders array found.');
    return null;
  }

  const restaurantId = ordersArray[0].restaurantId; // ดึง restaurantId ตัวแรกใน array
  console.log('Restaurant ID:', restaurantId);

  if (!restaurantId) {
    console.log('No restaurantId found in orders array.');
    return null;
  }

  // ไปดึง fcmToken ของร้าน
  const restaurantDoc = await admin.firestore().collection('users').doc(restaurantId).get();
  const restaurantFcmToken = restaurantDoc.data()?.fcmToken;

  if (!restaurantFcmToken) {
    console.log('No FCM token found for restaurant:', restaurantId);
    return null;
  }

  // ส่ง Notification ไปที่ร้าน
  const message = {
    token: restaurantFcmToken,
    notification: {
      title: 'New Order!',
      body: 'You have a new order!',
    },
    data: {
      orderId: event.params.orderId,
    },
  };

  try {
    await admin.messaging().send(message);
    console.log('Notification sent to restaurant:', restaurantId);
  } catch (error) {
    console.error('Error sending notification to restaurant:', error);
  }

  return null;
});

