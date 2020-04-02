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
      call.success([
          "value": value
      ])
  }
  
  @objc func getVideo(_ call: CAPPluginCall) {
    self.call = call;
    print("getVideo");
    DispatchQueue.main.async {
      print("getVideo2");
      self.imagePicker = UIImagePickerController();
      self.imagePicker!.delegate = self;
    }
    
    print("showVideos");
    self.showVideos(call);
    
  }
    
  func showVideos(_ call: CAPPluginCall) {
    DispatchQueue.main.async {
      let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
      if photoAuthorizationStatus == .restricted || photoAuthorizationStatus == .denied {
        call.error("User denied access to photos")
        return
      }

      self.configurePicker()

      self.imagePicker!.sourceType = .photoLibrary
      self.imagePicker!.mediaTypes = ["public.movie"]

      self.bridge.viewController.present(self.imagePicker!, animated: true, completion: nil)
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
    call?.success([
      "path" : videoURL?.absoluteString
    ])
    picker.dismiss(animated: true, completion: nil)
  }

  public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true)
    self.call?.error("User cancelled photos app")
  }
  
  public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    self.call?.error("User cancelled photos app")
  }
}
