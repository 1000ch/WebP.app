import Cocoa

class DropView: NSView, NSDraggingDestination {
    
    var cwebp: Compress2Webp = Compress2Webp()
    
    override init(frame: NSRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        registerForDraggedTypes([
            NSPasteboardTypePNG,
            NSColorPboardType,
            NSFilenamesPboardType
        ])
        //NSImage.imagePasteboardTypes()
        println(self.registeredDraggedTypes)
    }
    
    override func drawRect(dirtyRect: NSRect)  {
        super.drawRect(dirtyRect)
        NSColor.whiteColor().set()
        NSRectFill(dirtyRect)
    }
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation  {
        // implementation when drag is entered
        return NSDragOperation.Copy
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        
        // get dragged file paths
        let pboard = sender.draggingPasteboard()
        let filePaths = pboard.propertyListForType(NSFilenamesPboardType) as NSArray
        
        // load dropped file using NSFileManager
        let manager = NSFileManager.defaultManager()
        var error: NSError?

        for filePath in filePaths as [String] {
            let attributes = manager.attributesOfFileSystemForPath(filePath, error: &error)
            if error != nil {
                println("エラーでましてん…")
                println(error)
            } else {
                println("データとれましてん")

                let fileName: String = filePath.lastPathComponent
                var saveName: String = fileName.stringByReplacingOccurrencesOfString("/(jpeg|jpg|png)/", withString: "webp", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                
                saveName = saveName.stringByReplacingOccurrencesOfString("png", withString: "webp", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
                saveName = saveName.stringByReplacingOccurrencesOfString("jpg", withString: "webp", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)

                println(cwebp.execute(arguments: ["-o", saveName, filePath]))
            }
        }
        
        return true
    }

    override func draggingEnded(sender: NSDraggingInfo?) {
        // implementation when drag is ended
    }
}
