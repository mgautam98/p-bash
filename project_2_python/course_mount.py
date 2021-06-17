from argparse import ArgumentParser
from shutil import rmtree
from re import compile
from subprocess import run, PIPE, STDOUT
from exceptions import CourseNotFoundError, MoutError
import os


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
        self.data_dir = '/home/user1/Desktop/Project/project_2/courses'
        self.trainee_dir = '/home/user1/Desktop/Project/project_2/trainee'
        self.sudo_err = compile("only allowed if 'user_allow_other'")

    def get_courses(self) -> list:
        return self.courses

    def _check_course(self, course: str) -> bool:
        return course in [_get_basename(course_path)
                          for course_path in self.courses]

    def _check_mount(self, course: str) -> bool:

        mounted_course_path = os.path.join(self.trainee_dir, course)

        if os.path.isdir(mounted_course_path):
            s1 = run(['findmnt'], stdin=PIPE, stdout=PIPE,
                     stderr=STDOUT, text=True)
            s2 = run(['grep', '-c', mounted_course_path], stdout=PIPE,
                     stderr=STDOUT, text=True, input=s1.stdout)
            return int(s2.stdout) == 1
        return False

    def mount_course(self, course: str) -> None:
        if not self._check_course(course):
            raise CourseNotFoundError('Given course doesnot exists!')
        if self._check_mount(course):
            raise MoutError('Mount already exists!')
        # mkdir -p $TRAINEE_DIR/$1
        mount_course_path = os.path.join(self.trainee_dir, course)
        os.makedirs(mount_course_path)
        res = run(['bindfs', '-p', '550', '-u', 'trainee', '-g',
                   'ftpaccess', self.data_dir, mount_course_path],
                  stdout=PIPE, stderr=STDOUT)
        # only allowed if 'user_allow_other' is set
        if res.returncode == 1:
            rmtree(mount_course_path)
            if self.sudo_err.findall(res.stdout.decode()) != []:
                raise PermissionError('Files are owned by root!')
            else:
                raise MoutError('Can not mount!')

    def mount_all(self) -> None:
        for course_path in self.courses:
            self.mount_course(_get_basename(course_path))

    def umount_course(self, course: str) -> None:
        if not self._check_course(course):
            raise CourseNotFoundError('Given course doesnot exists!')
        if not self._check_mount(course):
            raise MoutError('Mount already exists!')

        path = os.path.join(self.trainee_dir, course)
        res = run(
            ['umount', path], stdout=PIPE, stderr=STDOUT)
        if res.returncode == 0:
            rmtree(path)
        else:
            raise MoutError('Can not unmount!')

    def umount_all(self) -> None:
        for course_path in self.courses:
            self.umount_course(_get_basename(course_path))


def _get_basename(path: str) -> str:
    return os.path.basename(path)


def list_courses(courses: list) -> None:
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
            course_mount.mount_course(args.course)
        else:
            course_mount.mount_all()
    elif args.umount:
        if args.course:
            course_mount.umount_course(args.course)
        else:
            course_mount.umount_all()
