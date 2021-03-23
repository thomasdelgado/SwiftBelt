//
//  PermissionManager.swift
//  
//
//  Created by Thomas Delgado on 02/03/21.
//
#if !os(watchOS)
import UIKit
import AVFoundation
import Combine

public class PermissionManager {
    public static func checkCameraPermission() -> Future<Bool, Never> {
        return Future { promise in
            checkCameraPermission {
                promise(.success($0))
            }
        }
    }

    public static func checkCameraPermission(result: @escaping (_ result: Bool) -> Void) {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        switch cameraAuthorizationStatus {
        case .denied, .restricted:
            result(false)
        case .authorized:
            result(true)
        case .notDetermined:
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                result(granted)
            }
        @unknown default:
            result(false)
        }
    }

    public static func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { _ in
            })
        }
    }
}
#endif
