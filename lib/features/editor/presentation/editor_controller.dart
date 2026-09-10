import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/services/html_beautifier.dart';
import '../../../core/storage/storage_service.dart';
import '../widgets/html_syntax_controller.dart';

class EditorController extends ChangeNotifier {
  final StorageService _storage;
  final HtmlSyntaxTextEditingController textController;
  final TextEditingController findController = TextEditingController();
  final TextEditingController replaceController = TextEditingController();

  // Scroll synchronization
  final ScrollController editorScrollController = ScrollController();
  final ScrollController gutterScrollController = ScrollController();

  // Undo / Redo stacks
  final List<String> _undoStack = [];
  final List<String> _redoStack = [];
  static const int _maxHistory = 60;
  bool _isPerformingUndoRedo = false;
  Timer? _historyDebounce;

  // Auto-save debounce
  Timer? _autoSaveTimer;

  // Search state
  bool _isFindReplaceOpen = false;
  int _currentMatchIndex = -1;

  // Title / filename
  String _currentTitle = 'index.html';
  bool _isDirty = false;

  EditorController(this._storage)
      : textController = HtmlSyntaxTextEditingController() {
    final initialCode = _storage.getCurrentHtml();
    textController.text = initialCode;
    _undoStack.add(initialCode);

    textController.addListener(_onTextChanged);

    // Sync scroll
    editorScrollController.addListener(() {
      if (gutterScrollController.hasClients &&
          gutterScrollController.offset != editorScrollController.offset) {
        gutterScrollController.jumpTo(editorScrollController.offset);
      }
    });
  }

  // Getters
  String get code => textController.text;
  int get lineCount => '\n'.allMatches(textController.text).length + 1;
  int get charCount => textController.text.length;
  bool get canUndo => _undoStack.length > 1;
  bool get canRedo => _redoStack.isNotEmpty;
  bool get isFindReplaceOpen => _isFindReplaceOpen;
  int get currentMatchIndex => _currentMatchIndex;
  int get totalMatches => textController.searchMatches.length;
  String get currentTitle => _currentTitle;
  bool get isDirty => _isDirty;

  void setTitle(String title) {
    _currentTitle = title;
    notifyListeners();
  }

  void _onTextChanged() {
    if (_isPerformingUndoRedo) return;

    _isDirty = true;

    // Debounce undo stack push
    _historyDebounce?.cancel();
    _historyDebounce = Timer(const Duration(milliseconds: 400), () {
      if (_undoStack.isEmpty || _undoStack.last != textController.text) {
        _undoStack.add(textController.text);
        if (_undoStack.length > _maxHistory) {
          _undoStack.removeAt(0);
        }
        _redoStack.clear();
        notifyListeners();
      }
    });

    // Debounce auto-save
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(milliseconds: 800), () {
      _storage.saveCurrentHtml(textController.text);
      _isDirty = false;
      notifyListeners();
    });

    if (_isFindReplaceOpen && findController.text.isNotEmpty) {
      _updateSearch();
    } else {
      notifyListeners();
    }
  }

  // Undo / Redo
  void undo() {
    if (!canUndo) return;
    _isPerformingUndoRedo = true;
    _redoStack.add(_undoStack.removeLast());
    final previousState = _undoStack.last;
    textController.text = previousState;
    _isPerformingUndoRedo = false;
    notifyListeners();
  }

  void redo() {
    if (!canRedo) return;
    _isPerformingUndoRedo = true;
    final nextState = _redoStack.removeLast();
    _undoStack.add(nextState);
    textController.text = nextState;
    _isPerformingUndoRedo = false;
    notifyListeners();
  }

  // Formatting
  void formatHtml() {
    final formatted = HtmlBeautifier.format(textController.text);
    if (formatted != textController.text) {
      _pushHistorySnapshot(formatted);
      textController.text = formatted;
      notifyListeners();
    }
  }

  // Load new code (e.g. from Template, History, or File)
  void loadCode(String newCode, {String? title}) {
    _pushHistorySnapshot(newCode);
    textController.text = newCode;
    if (title != null) _currentTitle = title;
    _storage.saveCurrentHtml(newCode);
    _isDirty = false;
    notifyListeners();
  }

  void _pushHistorySnapshot(String newCode) {
    if (_undoStack.isEmpty || _undoStack.last != newCode) {
      _undoStack.add(newCode);
      _redoStack.clear();
    }
  }

  // Find & Replace
  void toggleFindReplace() {
    _isFindReplaceOpen = !_isFindReplaceOpen;
    if (!_isFindReplaceOpen) {
      textController.updateSearch('', -1);
      _currentMatchIndex = -1;
    } else if (findController.text.isNotEmpty) {
      _updateSearch();
    }
    notifyListeners();
  }

  void onFindChanged(String query) {
    _currentMatchIndex = query.isEmpty ? -1 : 0;
    _updateSearch();
  }

  void _updateSearch() {
    final query = findController.text;
    textController.updateSearch(query, _currentMatchIndex);
    notifyListeners();
  }

  void nextMatch() {
    if (textController.searchMatches.isEmpty) return;
    _currentMatchIndex = (_currentMatchIndex + 1) % textController.searchMatches.length;
    _jumpToActiveMatch();
    textController.updateSearch(findController.text, _currentMatchIndex);
    notifyListeners();
  }

  void previousMatch() {
    if (textController.searchMatches.isEmpty) return;
    _currentMatchIndex = (_currentMatchIndex - 1 + textController.searchMatches.length) %
        textController.searchMatches.length;
    _jumpToActiveMatch();
    textController.updateSearch(findController.text, _currentMatchIndex);
    notifyListeners();
  }

  void _jumpToActiveMatch() {
    if (_currentMatchIndex < 0 || _currentMatchIndex >= textController.searchMatches.length) return;
    final match = textController.searchMatches[_currentMatchIndex];
    textController.selection = TextSelection(
      baseOffset: match.start,
      extentOffset: match.end,
    );
  }

  void replaceCurrent() {
    if (textController.searchMatches.isEmpty || _currentMatchIndex < 0) return;
    final match = textController.searchMatches[_currentMatchIndex];
    final original = textController.text;
    final replacement = replaceController.text;

    final newText = original.replaceRange(match.start, match.end, replacement);
    _pushHistorySnapshot(newText);
    textController.text = newText;

    _updateSearch();
  }

  void replaceAll() {
    final query = findController.text;
    if (query.isEmpty) return;
    final replacement = replaceController.text;
    final newText = textController.text.replaceAll(query, replacement);
    _pushHistorySnapshot(newText);
    textController.text = newText;
    _updateSearch();
  }

  // Quick text actions
  void copyAll() {
    Clipboard.setData(ClipboardData(text: textController.text));
  }

  Future<void> pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.isNotEmpty) {
      final current = textController.text;
      final selection = textController.selection;
      String newText;
      if (selection.isValid && selection.start >= 0 && selection.end >= 0) {
        newText = current.replaceRange(selection.start, selection.end, data.text!);
      } else {
        newText = current + data.text!;
      }
      _pushHistorySnapshot(newText);
      textController.text = newText;
      notifyListeners();
    }
  }

  void selectAll() {
    textController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: textController.text.length,
    );
  }

  void clearCode() {
    _pushHistorySnapshot('');
    textController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _historyDebounce?.cancel();
    _autoSaveTimer?.cancel();
    textController.removeListener(_onTextChanged);
    textController.dispose();
    findController.dispose();
    replaceController.dispose();
    editorScrollController.dispose();
    gutterScrollController.dispose();
    super.dispose();
  }
}
