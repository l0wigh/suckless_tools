//@ pragma UseQApplication
import Quickshell

ShellRoot {
    Variants {
        model: Config.enableLeftBar ? Quickshell.screens : []
        Bar {}
    }
    Variants {
        model: Config.enableTopBar ? Quickshell.screens : []
        TopBar {}
    }
    Variants {
        model: Config.enableBottomBar ? Quickshell.screens : []
        BottomBar {}
    }
    Variants {
        model: Config.enableRightBar ? Quickshell.screens : []
        RightBar {}
    }
    Variants {
        model: Quickshell.screens
        Osd {}
    }
}
