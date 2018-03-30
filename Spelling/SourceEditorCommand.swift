//
//  SourceEditorCommand.swift
//  Spelling
//
//  Created by Victor M on 27/03/2018.
//  Copyright © 2018 Victor M. All rights reserved.
//

import Foundation
import XcodeKit
import AppKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    let spellChecker = NSSpellChecker.shared

    let supportUTIs = ["public.swift-source"]

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        defer {
            completionHandler(nil)
        }

        let uti = invocation.buffer.contentUTI

        guard supportUTIs.contains(uti) else {
            return
        }

        //TODO: Move this methd
        spellChecker.learnWord("func")

        if let selectedLines = invocation.buffer.selections.firstObject as? XCSourceTextRange, selectedLines.start.line != selectedLines.end.line {

            extractSpelling(fromSelectedLines: selectedLines, invocation)
            return
        }

        extractSpellingFromPage(invocation)
    }

}

// MARK: Private Methods
extension SourceEditorCommand {

    private func extractSpellingSubstring(from text: String) -> Substring? {
        let checkRange = spellChecker.checkSpelling(of: text, startingAt: text.startIndex.encodedOffset)
        return text.substring(with: checkRange)
    }

    private func selectLine(at offset: Int) -> XCSourceTextRange {
        let textRange = XCSourceTextRange()
        textRange.start = XCSourceTextPosition(line: offset, column: 0)
        textRange.end = XCSourceTextPosition(line: offset + 1, column: 0)
        return textRange
    }

    private func extractSpellingFromPage(_ invocation: XCSourceEditorCommandInvocation) {

        for line in invocation.buffer.lines.lazy.enumerated() {
            guard let stringLine = line.element as? String else {
                continue
            }

            if let word = extractSpellingSubstring(from: stringLine) {
                let selectedLine = selectLine(at: line.offset)
                invocation.buffer.selections.add(selectedLine)
                invocation.buffer.lines.add("Word \(word) is incorrect in line \(line.offset + 1)")
            }
        }
    }

    private func extractSpelling(fromSelectedLines selectedLines: XCSourceTextRange, _ invocation: XCSourceEditorCommandInvocation) {

        for lineIndex in selectedLines.start.line ... selectedLines.end.line {
            guard let stringLine = invocation.buffer.lines[lineIndex] as? String else {
                continue
            }

            if let word = extractSpellingSubstring(from: stringLine) {
                invocation.buffer.lines.add("Word \(word) is incorrect in line \(lineIndex + 1)")
            }
        }
    }

}
