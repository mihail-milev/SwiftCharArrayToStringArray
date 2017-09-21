# SwiftCharArrayToStringArray
An example function how to convert an Objective-C or C array of strings into a Swift string array

# Why?
I am writing this short tutorial, because as a beginner in Swift I needed a couple of hours to find out how to parse an Objective-C array of strings (char pointers) to a Swift string array. I want to save all the people out there some time :)

# Educational literature
Before you continue, I think you should really know what are char pointers in C, what are arrays in C, how they are represented in memory and at last, but not least, how Swift deals with pointers. Finally, we use the Swift Reflection API, so you would also have to know it. If you already know all of this - please continue. Otherwise, be sure to read on the Internet about these topics. Here are my top links about them:
1. [Dennis Kubes's perfect explanation on arrays and memory addresses in C](https://denniskubes.com/2012/08/17/basics-of-memory-addresses-in-c/)
2. [A more educational point of view from the site of Swarthmore College Computer Science Department](https://www.cs.swarthmore.edu/~newhall/unixhelp/C_arrays.html)
3. [A very simple explanation about strings in C from Boston University's site](https://www.cs.bu.edu/teaching/cpp/string/array-vs-ptr/)
4. [Ray Wenderlich's page on "Unsafe Swift"](https://www.raywenderlich.com/148569/unsafe-swift)
5. [Benedikt Terhechte's great explanation of the Swift Reflection API](https://appventure.me/2015/10/24/swift-reflection-api-what-you-can-do/)

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
        var ret : [String] = [] // 1
        let bigTuple = LIST_OF_CURRENCIES // 2
        for bigTupleChild in Mirror(reflecting: bigTuple).children { // 3
            let cArrayElementPointer : UnsafePointer<Int8> = bigTupleChild.value as! UnsafePointer<Int8> // 4
            let strData : Data = Data(bytes: cArrayElementPointer, count: Int(3)) // 5
            let finalString : String = String(data: strData, encoding: String.Encoding.utf8)! // 6
            ret.append(finalString) // 7
        }
        return ret // 8
    }
```
# Explanation
## Line 1
We define here a variable array, to which we are going to append the strings from the static array. This is going to be our return variable.
## Line 2
Why do we call the parameter "bigTuple"? Because this is how Swift "sees" the static char pointer array. It really "sees" it as a big tuple of pointers. So actually for Swift LIST_OF_CURRENCIES is of type (UnsafePointer<Int8>?, UnsafePointer<Int8>?, UnsafePointer<Int8>?, ... ) and so one.
## Line 3
The "Mirror" function is part of the Swift Reflection API. I found [this tutorial](https://appventure.me/2015/10/24/swift-reflection-api-what-you-can-do/) to be very interesting and informative on this topic. In our case, the Mirror function allows us to programmatically iterate over the tuple, without needing to hard code 160 (in some cases probably more) requests to the tuple. You can imagine this, as creating an iterator over the tuple.
## Line 4
As stated in the comment for Line 2, each element of the tuple is actually a pointer to 8 bits. Swift provides us in such cases with the typed unsafe pointer: UnsafePointer<Int8>.
## Line 5
We can now convert this UnsafePointer<Int8> to a Data (NSData for Objective-C fans) object. Here is a tricky part. You must know how long your string is. I have it easy, because my strings are always 3 characters big. Of course, there are methods to overcome this problem, by searching for the '\0' character, counting, etc. But this can get ugly. My suggestion in case you have strings of different length: padd all of them to the length of the longest one with empty spaces. Then at line 7 below, trim them.
## Line 6
We can now use the String initializator with the option "data" to convert this Data object to a string.
## Line 7
Append the new string to our array. Trim if needed.
## Line 8
Finally return your new array. And voilà! You now have converted a C-style char pointer array to a Swift String array.
