import sublime
import sublime_plugin

class WordHighlightListener(sublime_plugin.EventListener):
    def on_selection_modified(self, view):
        regions = []
        for sel in view.sel():
            if len(sel):
                regions += view.find_all(view.substr(sel))
        view.add_regions("WordHighlight", regions, "comment", 0)