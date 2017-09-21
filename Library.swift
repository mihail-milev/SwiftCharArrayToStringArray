import Foundation

class Library {
    private func currArrTest() -> [String] {
        var ret : [String] = []
        let bigTuple = LIST_OF_CURRENCIES
        for bigTupleChild in Mirror(reflecting: bigTuple).children {
            let cArrayElementPointer : UnsafePointer<Int8> = bigTupleChild.value as! UnsafePointer<Int8>
            let strData : Data = Data(bytes: cArrayElementPointer, count: Int(3))
            let finalString : String = String(data: strData, encoding: String.Encoding.utf8)!
            ret.append(finalString)
        }
        return ret
    }
}
