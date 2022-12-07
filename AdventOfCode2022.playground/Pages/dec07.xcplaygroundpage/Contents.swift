import Foundation

let ELFDEVICESPACE = 70000000
let UPDATESIZE = 30000000

struct File {
    let name: String
    let size: Int
}

class Directory {
    let name: String
    var files: [File] = []
    var subDirectories: [String : Directory] = [:]
    var parent: Directory? = nil
    
    init(name: String, subDirectories: [String : Directory] = [:], parent: Directory? = nil) {
        self.name = name
        self.subDirectories = subDirectories
        self.parent = parent
    }
    
    var size: Int {
        var size = 0
        subDirectories.values.forEach { size += $0.size }
        files.forEach { size += $0.size }
        return size
    }
}

struct ElfDevice {
    
    var root: Directory = {
        let home = Directory(name: "/")
        let root = Directory(name: "root", subDirectories: ["/" : home])
        home.parent = root
        return root
    }()
    
    let terminalLines: [String]
    var maxDirectorySizeForDelete = 100000
    var spaceToFree = 0
    var deleteSize = 70000000
    
    mutating func buildDirectory(_ commandIndex: Int = 0, directory: Directory?) {
        guard commandIndex < terminalLines.count else { return }
        
        let command = terminalLines[commandIndex]
        let nextIndex = commandIndex + 1
        let components = command.components(separatedBy: .whitespaces)
        
        if let size = Int(components[0]) {
            // parse file
            let file = File(name: components[1], size: size)
            directory?.files.append(file)
            buildDirectory(nextIndex, directory: directory)
        } else {
            if components[0] == "dir" {
                // parse subdirectory
                let subDirectory = Directory(name: components[1], parent: directory)
                directory?.subDirectories[components[1]] = subDirectory
                buildDirectory(nextIndex, directory: directory)
            } else {
                if components[1] == "cd" {
                    // going back to parent
                    if components[2] == ".." {
                        buildDirectory(nextIndex, directory: directory?.parent)
                    } else {
                        // going into a subdirectory
                        buildDirectory(nextIndex, directory: directory?.subDirectories[components[2]])
                    }
                } else {
                    // ls command (pass)
                    buildDirectory(nextIndex, directory: directory)
                }
            }
        }
    }
    
    mutating func getSmallestSizeToDelete(_ directory: Directory) -> Int {
        let size = directory.size
        if size >= spaceToFree && size < deleteSize {
            deleteSize = size
        }
        directory.subDirectories.values.forEach {
            if getSmallestSizeToDelete($0) < deleteSize {
                deleteSize = size
            }
        }
        return deleteSize
    }
    
    func getDeletableSize(_ directory: Directory) -> Int {
        var size = 0
        directory.subDirectories.values.forEach {
            let dirSize = $0.size
            if dirSize <= maxDirectorySizeForDelete {
                size += dirSize
            }
            size += getDeletableSize($0)
        }
        return size
    }
}

//MARK: - Part 1

func part1() -> Int {
    let helper = InputHelper(fileName: "dec07Input")
    let input = helper.inputAsArraySeparatedBy(.newlines)
    
    var device = ElfDevice(terminalLines: input)
    device.buildDirectory(0, directory: device.root)
    
    return device.getDeletableSize(device.root)
}

//MARK: - Part 2

func part2() -> Int {
    let helper = InputHelper(fileName: "dec07Input")
    let input = helper.inputAsArraySeparatedBy(.newlines)
    
    var device = ElfDevice(terminalLines: input)
    device.buildDirectory(directory: device.root)
    let unusedSpace = ELFDEVICESPACE - (device.root.size)
    device.spaceToFree = UPDATESIZE - unusedSpace
    
    return device.getSmallestSizeToDelete(device.root)
}

print(part1())
print(part2())
