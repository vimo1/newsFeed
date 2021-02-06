import Foundation

/// Instances of types conforming to this protocol provide access to the file system through this interface.
/// A protocol used in place of direct access to NSFileManager so that use of the file system can be tested.
public protocol FileManaging {

    /// Creates a file with the specified content and attributes at the given location.
    ///
    /// - parameter atPath: The path for the new file.
    /// - parameter contents: A data object containing the contents of the new file.
    /// - parameter attributes: A dictionary containing the attributes to associate with the new file.
    /// For a list of keys, see File Attribute Keys.
    ///
    /// - returns: True if the operation was successful or if the item already exists, otherwise false.
    func createFile(atPath: String, contents: Data?, attributes: [FileAttributeKey: Any]?) -> Bool

    /// Moves the file or directory at the specified URL to a new location synchronously.
    ///
    /// - important: The `url` must not be a file reference URL and must include the name of the file or directory
    /// in its new location.
    ///
    /// - parameter url: The file URL that identifies the file or directory you want to move.
    /// The URL in this parameter must not be a file reference URL.
    /// - parameter to: The new location for the item in srcURL.
    /// - throws: An NSError if the file could not be moved.
    func moveItem(at url: URL, to: URL) throws

    /// Performs a shallow search of the specified directory and returns URLs for the contained items.
    ///
    /// - parameter url: The location of the directory to search.
    /// - parameter keys: Keys that identify the file properties that you want pre-fetched for each item in the directory.
    /// - parameter mask: The only supported option is skipsHiddenFiles.
    ///
    /// - returns: URLs which identifies a file, directory, or symbolic link contained in url.
    /// - throws: an NSError if there is a problem reading the directory.
    func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions) throws -> [URL]

    /// Creates a directory at `url`.
    ///
    /// - parameter url: The URL to create the directory at.
    /// - parameter createIntermediates: Whether to create any directories in the path that don't yet exist.
    /// - parameter attributes: Use this parameter to further customize the behavior of this function.
    ///
    /// - throws: an NSError if the directory could not be created.
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey: Any]?) throws

    /// Checks if a file exists.
    ///
    /// - parameter atPath: The path of the file to check.
    ///
    /// - returns: Whether the file exists.
    func fileExists(atPath: String) -> Bool

    /// Creates a handle for the file at url, suitable for writing.
    ///
    /// - parameter forWritingToURL: The url of the file
    ///
    /// - returns: The writing handle
    /// - throws: An NSError
    func createFileHandle(forWritingToURL: URL) throws -> FileHandle

    /// Reads the contents of `url` into a `String`. Assumes the file is UTF-8 encoded.
    ///
    /// - parameter url: The URL to read.
    ///
    ///
    /// - returns: The contents of the URL as a String.
    /// - throws: An NSError if the file could not be read into a String.
    func read(contentsOf url: URL) throws -> String

    /// Serializes a dictionary and writes it to `url`.
    ///
    /// - parameter dictionary: The dictionary to write.
    /// - parameter url: The location to write the dictionary to.
    /// - parameter atomically: If the write operation should be atomic.
    ///
    /// - returns: Whether the operation succeeded.
    @discardableResult
    func write(dictionary: [String: Any], to url: URL, atomically: Bool) -> Bool

    /// Writes data to a url.
    ///
    /// - parameter data: The data to write to disk.
    /// - parameter url: The location to save `data` to.
    /// - options: Further customization options.
    ///
    /// - throws: An NSError if the data could not be saved.
    func write(data: Data, to url: URL, options: Data.WritingOptions) throws

    /// Reads the file at `url` into a dictionary.
    ///
    /// - parameter url: The location to read the dictionary from.
    ///
    /// - returns: A dictionary, or nil if the file didn't exist or couldn't be deserialized.
    func read(dictionaryAt url: URL) -> [String: Any]?

    /// Reads a file into memory.
    ///
    /// - parameter url: The location to read the file from.
    ///
    /// - returns: The data at `url`, or `nil` if the file didn't exist or couldn't be read.
    func data(forURL url: URL) -> Data?

    /// Determines whether the file at `url` is deletable.
    ///
    /// - parameter url: The location to check.
    ///
    /// - returns: Whether the file at `url` is deletable.
    func isDeletableFile(atURL url: URL) -> Bool

    /// Removes the file at URL.
    ///
    /// - parameter URL: The location of the file to delete.
    /// - throws: An NSError if the file could not be removed.
    func removeItem(at URL: URL) throws

    /// Locates and optionally creates the specified common directory in a domain.
    /// You typically use this method to locate one of the standard system directories.
    /// After locating (or creating) the desired directory, this method returns the URL for that directory.
    /// If more than one appropriate directory exists in the specified domain,
    /// this method returns only the first one it finds.
    ///
    /// - parameter directory: The search path to retrieve a URL for.
    /// - parameter domain: The domain to search in.
    ///
    /// - returns: The URL for the directory in the domain
    /// - throws: An NSException if the directory and domain pair are incompatible
    /// (such as desktopDirectory and networkDomainMask)
    func url(for directory: FileManager.SearchPathDirectory, in domain: FileManager.SearchPathDomainMask) throws -> URL

    /// Returns an array of URLs for the specified common directory in the requested domains.
    /// This method is intended to locate known and common directories in the system.
    /// There are a number of common directories available in the `FileManager.SearchPathDirectory`
    /// - desktopDirectory
    /// - applicationSupportDirectory
    /// and many more.
    ///
    /// - parameter directory: The search path directory
    /// - parameter domainMask: The file system domain to search
    ///
    /// - returns: URLs identifying the requested directories, ordered according to the order of the domain mask constants.
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL]

    /// Copies the file or directory at the specified URL to a new location synchronously.
    ///
    /// - important: The `url` must not be a file reference URL and must include the name of the file or directory
    /// in its new location.
    ///
    /// - parameter srcURL: The file URL that identifies the file or directory you want to copy.
    /// The URL in this parameter must not be a file reference URL.
    /// - parameter dstURL: The new location for the item in srcURL.
    /// - throws: An NSError if the file could not be moved.
    func copyItem(at srcURL: URL, to dstURL: URL) throws

    /// Sets the attributes at a specified url.
    ///
    /// - parameter values: the values to set
    /// - parameter url: the url to set the values on
    /// - throws: The NSError provided by the system if setting the resource values fails.
    func setResourceValues(_ values: URLResourceValues, at url: inout URL) throws

}

extension FileManager: FileManaging {
    public func write(data: Data, to url: URL, options: Data.WritingOptions) throws {
        try data.write(to: url, options: options)
    }

    public func createFileHandle(forWritingToURL: URL) throws -> FileHandle {
        return try FileHandle(forWritingTo: forWritingToURL)
    }

    public func read(contentsOf url: URL) throws -> String {
        return try String(contentsOf: url, encoding: String.Encoding.utf8)
    }

    public func write(dictionary: [String: Any], to url: URL, atomically: Bool) -> Bool {
        return (dictionary as NSDictionary).write(to: url as URL, atomically: atomically)
    }

    public func read(dictionaryAt url: URL) -> [String: Any]? {
        return NSDictionary(contentsOf: url as URL) as? [String: Any]
    }

    public func data(forURL url: URL) -> Data? {
        return try? Data(contentsOf: url)
    }

    public func isDeletableFile(atURL url: URL) -> Bool {
        return isDeletableFile(atPath: url.path)
    }

    public func url(for directory: FileManager.SearchPathDirectory, in domain: FileManager.SearchPathDomainMask) throws -> URL {
        return try url(for: directory, in: domain, appropriateFor: nil, create: true)
    }

    public func setResourceValues(_ values: URLResourceValues, at url: inout URL) throws {
        try url.setResourceValues(values)
    }
}
