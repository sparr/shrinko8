from utils import *
from pico_tokenize import TokenType, Token
from pico_parse import NodeType

def is_node_function_stmt(node):
    return (node.type == NodeType.function and node.target) or (node.type == NodeType.local and node.func_local)

def unminify_code(root, unminify):
    
    indent_delta = 2
    if isinstance(unminify, dict):
        indent_delta = unminify.get("indent", indent_delta)

    output = []
    prev_token = Token.dummy(None)
    prev_tight = False
    indent = 0
    short_count = 0
    curr_stmt = None
    stmt_stack = []

    k_tight_prefix_tokens = ("(", "[", "{", "?", ".", ":", "::")
    k_tight_suffix_tokens = (")", "]", "}", ",", ";", ".", ":", "::")

    def visit_token(token):
        nonlocal prev_token, prev_tight

        for comment in token.children:
            comment_value = comment.value
            if "\n" in comment_value:
                if prev_tight:
                    output.append("\n")
                    output.append(" " * indent)
                output.append(comment_value)
                if not comment_value.endswith("\n"):
                    output.append("\n")
                output.append(" " * indent)
            else:
                if prev_tight and prev_token.value not in k_tight_prefix_tokens:
                    output.append(" ")
                output.append(comment_value)
            prev_tight = False

        if token.value is None:
            return

        if prev_tight and prev_token.value not in k_tight_prefix_tokens and \
                token.value not in k_tight_suffix_tokens and \
                not (token.value in ("(", "[") and (prev_token.type == TokenType.ident or 
                                                    prev_token.value in ("function", ")", "]", "}"))) and \
                not (prev_token.type == TokenType.punct and prev_token.parent.type == NodeType.unary_op):
            output.append(" ")

        output.append(token.value)
        prev_token = token
        prev_tight = True

    def visit_node(node):
        nonlocal indent, curr_stmt, short_count, prev_tight

        if node.type == NodeType.block:
            if node.parent:
                indent += indent_delta
                if getattr(node.parent, "short", False):
                    short_count += 1

            stmt_stack.append(curr_stmt)
            curr_stmt = None
            output.append(" " if short_count else "\n")
            prev_tight = False

            if short_count and not node.children:
                output.append(";")

        elif curr_stmt is None:
            if is_node_function_stmt(node):
                child_i = node.parent.children.index(node)
                if child_i > 0 and not is_node_function_stmt(node.parent.children[child_i - 1]):
                    output.append("\n")

            curr_stmt = node
            if short_count:
                if node.parent.children[0] != node:
                    output.append(";")
            else:
                output.append(" " * indent)
                prev_tight = False

    def end_visit_node(node):
        nonlocal indent, curr_stmt, short_count, prev_tight

        if node.type == NodeType.block:
            if node.parent:
                indent -= indent_delta

            curr_stmt = stmt_stack.pop()
            if not short_count:
                output.append(" " * indent)
                prev_tight = False
                
            if node.parent and getattr(node.parent, "short", False):
                short_count -= 1

        elif node is curr_stmt:
            curr_stmt = None
            if not short_count:
                output.append("\n")
                prev_tight = False
                
            if is_node_function_stmt(node):
                output.append("\n")

    root.traverse_nodes(visit_node, end_visit_node, tokens=visit_token)

    return "".join(output)
