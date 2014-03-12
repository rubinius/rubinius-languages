require 'kpeg/compiled_parser'

class Plus < KPeg::CompiledParser


  attr_accessor :result


  # :stopdoc:

  # ws = /[ \t\n]+/
  def _ws
    _tmp = scan(/\A(?-mix:[ \t\n]+)/)
    set_failed_rule :_ws unless _tmp
    return _tmp
  end

  # number = < /[0-9]*/ > { text.to_i }
  def _number

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:[0-9]*)/)
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  text.to_i ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_number unless _tmp
    return _tmp
  end

  # expr = (expr:e1 ws "+" ws expr:e2 { e1 + e2 } | number)
  def _expr

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_expr)
        e1 = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_ws)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("+")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_ws)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_expr)
        e2 = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  e1 + e2 ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      _tmp = apply(:_number)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_expr unless _tmp
    return _tmp
  end

  # root = expr:e { @result = e }
  def _root

    _save = self.pos
    while true # sequence
      _tmp = apply(:_expr)
      e = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  @result = e ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_root unless _tmp
    return _tmp
  end

  Rules = {}
  Rules[:_ws] = rule_info("ws", "/[ \\t\\n]+/")
  Rules[:_number] = rule_info("number", "< /[0-9]*/ > { text.to_i }")
  Rules[:_expr] = rule_info("expr", "(expr:e1 ws \"+\" ws expr:e2 { e1 + e2 } | number)")
  Rules[:_root] = rule_info("root", "expr:e { @result = e }")
  # :startdoc:
end
