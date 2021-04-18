//
//  Utility.swift
// Code inside modules can be shared between pages and other source files.
//

import UIKit

extension UIButton{
    public func stringTag() -> String{
        return self.currentTitle!
    }
}

public func getNextPage() -> String {
    
    return "\n\n[**Next Page**](@next)"
    
}
