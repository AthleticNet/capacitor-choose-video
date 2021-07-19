import Foundation
import Capacitor
import Photos

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(CapacitorChooseVideo)
public class CapacitorChooseVideo: CAPPlugin, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
  var imagePicker: UIImagePickerController?
  var call: CAPPluginCall?
  var videoURL: NSURL?

  @objc func echo(_ call: CAPPluginCall) {
      print("in echo");
      let value = call.getString("value") ?? ""
      call.resolve([
          "value": value
      ])
  }
  
  @objc func requestFilesystemAccess(_ call: CAPPluginCall) {
    print("in requestFilesystemAccess")
      DispatchQueue.main.async {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if photoAuthorizationStatus == .notDetermined {
          // Access has not been determined.
          PHPhotoLibrary.requestAuthorization({ (newStatus) in
              if (newStatus == PHAuthorizationStatus.authorized) {
                call.resolve([
                    "hasPermission": true
                ])
              }
              else {
                call.reject("User denied access to photos");
              }
          })
        }
        if photoAuthorizationStatus == .restricted || photoAuthorizationStatus == .denied {
          print("User denied access to photos")
          call.reject("User denied access to photos");
          return
        }

        call.resolve([
            "hasPermission": true
        ])
      }
  }

  @objc func getVideo(_ call: CAPPluginCall) {
    self.call = call;
    DispatchQueue.main.async {
      self.imagePicker = UIImagePickerController();
      self.imagePicker!.delegate = self;
    }
    
    self.showVideos(call);
  }
    
  func showVideos(_ call: CAPPluginCall) {
    DispatchQueue.main.async {
      let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
      if photoAuthorizationStatus == .restricted || photoAuthorizationStatus == .denied {
        call.reject("User denied access to photos")
        return
      }

      self.configurePicker()

      self.imagePicker!.sourceType = .photoLibrary
      self.imagePicker!.mediaTypes = ["public.movie"]

      self.bridge?.viewController?.present(self.imagePicker!, animated: true, completion: nil)
    }
  }
    
  private func configurePicker() {
    self.imagePicker!.modalPresentationStyle = .popover
    self.imagePicker!.popoverPresentationController?.delegate = self
    self.setCenteredPopover(self.imagePicker!)
  }
    // TODO: This function isn't being called. The popup comes up and all is good, but I need
    // TODO: to figure out how to get this controller function to be called.
  public func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
  ) {
    print("in imagePickerController");
    videoURL = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerMediaURL")] as? NSURL
    print("info");
    print(videoURL)
    dump(info);
    call?.resolve([
      "path" : videoURL?.absoluteString
    ])
    picker.dismiss(animated: true, completion: nil)
  }

  public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true)
    self.call?.reject("User cancelled photos app")
  }
  
  public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    self.call?.reject("User cancelled photos app")
  }
}
