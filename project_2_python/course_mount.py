from argparse import ArgumentParser
from os import basename


class CourseMount:
    def __init__(self):
        self.courses = [
            'Linux_course/Linux_course1',
            'Linux_course/Linux_course2',
            'machinelearning/machinelearning1',
            'machinelearning/machinelearning2',
            'SQLFundamentals1',
            'SQLFundamentals2',
            'SQLFundamentals3',
        ]
        self.data_dir = './courses'
        self.trainee_dir = './trainee'

    def get_courses(self):
        return self.courses

    def _check_course(self, course: str):
        pass

    def _check_mount(self, course: str):
        pass

    def mount_course(self, course: str):
        pass

    def mount_all(self):
        pass

    def umount_course(self, course: str):
        pass

    def umount_all(self):
        pass


def _get_basename(path: str):
    return basename(path)


def list_courses(courses: list):
    print('')
    for course in courses:
        print(f"\t{course}")
    print('')


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument('-l', '--list', help='Shpw all available courses',
                        action='store_true')
    parser.add_argument('-m', '--mount', help='For mounting a given course',
                        action='store_true')
    parser.add_argument('-u', '--umount', help='For unmounting a given course',
                        action='store_true')
    parser.add_argument('-c', '--course', help='Course name', type=str)
    args = parser.parse_args()

    course_mount = CourseMount()

    if args.mount and args.umount:
        parser.print_help()
    elif args.list:
        list_courses(course_mount.get_courses())
    elif args.mount:
        if args.course:
            course_mount.mount(args.course)
        else:
            course_mount.mount_all()
    elif args.umount:
        if args.course:
            course_mount.umount(args.course)
        else:
            course_mount.umount_all()
