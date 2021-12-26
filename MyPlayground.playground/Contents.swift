import UIKit
import Foundation

for _ in 1...10 {
   DispatchQueue.main.async {
      print("task")
   }
}

print("main")
