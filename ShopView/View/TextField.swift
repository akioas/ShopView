import UIKit

class TextField: UITextField {
    let inset: CGFloat = 40

    override func textRect(forBounds: CGRect) -> CGRect {
        return forBounds.insetBy(dx: self.inset, dy: 0)
    }
    override func editingRect(forBounds: CGRect) -> CGRect {
        return forBounds.insetBy(dx: self.inset, dy: 0)
    }
}
