# SwiftCharArrayToStringArray
An example function how to convert an Objective-C or C array of strings into a Swift string array

# Why?
I am writing this short tutorial, because as a beginner in Swift I needed a couple of hours to find out how to parse an Objective-C array of strings (char pointers) to a Swift string array. I want to save all the people out there some time :)

# Educational literature
Before you continue, I think you should really know what are char pointers in C, what are arrays in C, how they are represented in memory and at last, but not least, how Swift deals with pointers. If you already know this - please continue. Otherwise, be sure to read on the Internet about these topics. Here are my top links about these topics:
1. [Dennis Kubes's perfect explanation on arrays and memory addresses in C](https://denniskubes.com/2012/08/17/basics-of-memory-addresses-in-c/)
2. [A more educational point of view from the site of Swarthmore College Computer Science Department](https://www.cs.swarthmore.edu/~newhall/unixhelp/C_arrays.html)
3. [A very simple explanation about strings in C from Boston University's site](https://www.cs.bu.edu/teaching/cpp/string/array-vs-ptr/)
4. [Ray Wenderlich's page on "Unsafe Swift"](https://www.raywenderlich.com/148569/unsafe-swift)

# Preparation
You basically need two files in your project:
1. A C header file, which contains the static char pointer array and (since we know how big this array is) a static constant containing the size of the array.
2. A Swift class, or playground, which have access to the header.

# The static char pointer array
It could look something like this in your header. I am using here a long list of all possible (hopefully) currencies in the world (source: [List of currencies of the world](https://www.countries-ofthe-world.com/world-currencies.html)).
```C
static unsigned int LIST_OF_CURRENCIES_COUNT = 160;
static const char* LIST_OF_CURRENCIES[] = {"AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN", "BAM", "BBD", "BDT", "BGN", "BHD", "BIF", "BMD", "BND", "BOB", "BRL", "BSD", "BTN", "BWP", "BYN", "BYR", "BZD", "CAD", "CDF", "CHF", "CLP", "CNY", "COP", "CRC", "CUC", "CUP", "CVE", "CZK", "DJF", "DKK", "DOP", "DZD", "EGP", "ERN", "ETB", "EUR", "FJD", "FKP", "GBP", "GEL", "GGP", "GHS", "GIP", "GMD", "GNF", "GTQ", "GYD", "HKD", "HNL", "HRK", "HTG", "HUF", "IDR", "ILS", "IMP", "INR", "IQD", "IRR", "ISK", "JEP", "JMD", "JOD", "JPY", "KES", "KGS", "KHR", "KMF", "KPW", "KRW", "KWD", "KYD", "KZT", "LAK", "LBP", "LKR", "LRD", "LSL", "LYD", "MAD", "MDL", "MGA", "MKD", "MMK", "MNT", "MOP", "MRO", "MUR", "MVR", "MWK", "MXN", "MYR", "MZN", "NAD", "NGN", "NIO", "NOK", "NPR", "NZD", "OMR", "PAB", "PEN", "PGK", "PHP", "PKR", "PLN", "PRB", "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SAR", "SBD", "SCR", "SDG", "SEK", "SGD", "SHP", "SLL", "SOS", "SRD", "SSP", "STD", "SYP", "SZL", "THB", "TJS", "TMT", "TND", "TOP", "TRY", "TTD", "TVD", "TWD", "TZS", "UAH", "UGX", "USD", "UYU", "UZS", "VEF", "VND", "VUV", "WST", "XAF", "XCD", "XOF", "XPF", "YER", "ZAR", "ZMW"};
```

# The Swift function
Here is the source code and after it, I will try to explain what happens on each line.
```Swift
private func currArrTest() -> [String] {
    return withUnsafePointer(to: &LIST_OF_CURRENCIES, {(_ param: UnsafePointer) -> [String] in // 1
        var ret : [String] = [] // 2
        let bigTuple = param.pointee // 3
        for bigTupleChild in Mirror(reflecting: bigTuple).children { // 4
            let cArrayElementPointer : UnsafePointer<Int8> = bigTupleChild.value as! UnsafePointer<Int8> // 5
            let strData : Data = Data(bytes: cArrayElementPointer, count: Int(3)) // 6
            let finalString : String = String(data: strData, encoding: String.Encoding.utf8)! // 7
            ret.append(finalString) // 8
        }
        return ret // 9
    })
}
```
