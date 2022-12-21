import ArgumentParser

let ELFDEVICESPACE = 70000000
let UPDATESIZE = 30000000

struct Dec072022: ParsableCommand, AOCDay {
    static let configuration = CommandConfiguration(abstract: "Advent of Code - No Space Left On Device", version: "1.0.0")

    @Option(name: .shortAndLong, help: "Input file path")
    var path: String = "Input/dec072022.txt"

    // MARK: - Data Structures

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

    // MARK: - Lifecycle

    mutating func run() throws {
        let lines  = try String(contentsOfFile: path).components(separatedBy: .newlines)

        print("Part 1: \(part1(lines))")
        print("Part 2: \(part2(lines))")
    }

    // MARK: - Part 1

    func part1(_ lines: [String]) -> Int {
        var device = ElfDevice(terminalLines: lines)
        device.buildDirectory(0, directory: device.root)
    
        return device.getDeletableSize(device.root)
    }

    // MARK: - Part 2

    func part2(_ lines: [String]) -> Int {
        var device = ElfDevice(terminalLines: lines)
        device.buildDirectory(directory: device.root)
        let unusedSpace = ELFDEVICESPACE - (device.root.size)
        device.spaceToFree = UPDATESIZE - unusedSpace
        
        return device.getSmallestSizeToDelete(device.root)
    }
}