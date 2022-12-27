struct Point3D: Hashable{
    enum Axis {
        case x
        case y
        case z
    }

        let x: Int
        let y: Int
        let z: Int

        var connectedPoints: Set<Point3D> {
            return Set<Point3D>([Point3D(x: x - 1, y: y, z: z), Point3D(x: x + 1, y: y, z: z),
                                 Point3D(x: x, y: y - 1, z: z), Point3D(x: x, y: y + 1, z: z),
                                 Point3D(x: x, y: y, z: z + 1), Point3D(x: x, y: y, z: z - 1)
                                ])
        }
}

extension Point3D: CustomStringConvertible {
    var description: String {
        return ("x: \(x) y: \(y) z: \(z)")
    }
}