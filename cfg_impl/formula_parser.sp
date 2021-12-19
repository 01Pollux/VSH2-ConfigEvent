/**
 * Remade FF2 formula parser by Nergal.
 */

enum {
	TokenInvalid,
	TokenNum,
	TokenLParen, TokenRParen,
	TokenLBrack, TokenRBrack,
	TokenPlus, TokenSub,
	TokenMul, TokenDiv,
	TokenPow,
	TokenVar
};

enum {
	LEXEME_SIZE=64,
	dot_flag = 1,
};

enum struct Token {
	char lexeme[LEXEME_SIZE];
	int size;
	int tag;
	float val;
}

enum struct LexState {
	Token tok;
	int i;
}
/**
 * formula grammar (hint PEMDAS):
 * expr      = <add_expr> ;
 * add_expr  = <mult_expr> [ ('+' | '-') <add_expr> ] ;
 * mult_expr = <pow_expr> [ ('*' | '/') <mult_expr> ] ;
 * pow_expr  = <factor> [ '^' <pow_expr> ] ;
 * factor    = <number> | <var> | '(' <expr> ')' | '[' <expr> ']' ;
 */

float ParseFormula(const char[] formula, const int players)
{
	float vals[4];
	vals[0] = players + 0.0;
	vals[1] = players + 0.0;
	vals[2] = players + 0.0;
	vals[3] = players + 0.0;
	return ParseFormulaEx(formula, "nNxX", vals, sizeof(vals));
}

float ParseFormulaEx(const char[] formula, const char[] tokens, const float[] values, int token_size)
{
	LexState ls;
	GetToken(ls, formula, tokens, values, token_size);
	return ParseAddExpr(ls, formula, tokens, values, token_size);
}

float ParseAddExpr(LexState ls, const char[] formula, const char[] tokens, const float[] values, int token_size)
{
	float val = ParseMulExpr(ls, formula, tokens, values, token_size);
	if( ls.tok.tag==TokenPlus ) {
		GetToken(ls, formula, tokens, values, token_size);
		float a = ParseAddExpr(ls, formula, tokens, values, token_size);
		return val + a;
	} else if( ls.tok.tag==TokenSub ) {
		GetToken(ls, formula, tokens, values, token_size);
		float a = ParseAddExpr(ls, formula, tokens, values, token_size);
		return val - a;
	}
	return val;
}

float ParseMulExpr(LexState ls, const char[] formula, const char[] tokens, const float[] values, int token_size)
{
	float val = ParsePowExpr(ls, formula, tokens, values, token_size);
	if( ls.tok.tag==TokenMul ) {
		GetToken(ls, formula, tokens, values, token_size);
		float m = ParseMulExpr(ls, formula, tokens, values, token_size);
		return val * m;
	} else if( ls.tok.tag==TokenDiv ) {
		GetToken(ls, formula, tokens, values, token_size);
		float m = ParseMulExpr(ls, formula, tokens, values, token_size);
		return val / m;
	}
	return val;
}

float ParsePowExpr(LexState ls, const char[] formula, const char[] tokens, const float[] values, int token_size)
{
	float val = ParseFactor(ls, formula, tokens, values, token_size);
	if( ls.tok.tag==TokenPow ) {
		GetToken(ls, formula, tokens, values, token_size);
		float e = ParsePowExpr(ls, formula, tokens, values, token_size);
		float p = Pow(val, e);
		return p;
	}
	return val;
}

float ParseFactor(LexState ls, const char[] formula, const char[] tokens, const float[] values, int token_size)
{
	switch( ls.tok.tag ) {
		case TokenNum, TokenVar: {
			float f = ls.tok.val;
			GetToken(ls, formula, tokens, values, token_size);
			return f;
		}
		case TokenLParen: {
			GetToken(ls, formula, tokens, values, token_size);
			float f = ParseAddExpr(ls, formula, tokens, values, token_size);
			if( ls.tok.tag != TokenRParen ) {
				LogError("[VSH2 CfgEvent] :: expected ')' bracket but got '%s'", ls.tok.lexeme);
				return 0.0;
			}
			GetToken(ls, formula, tokens, values, token_size);
			return f;
		}
		case TokenLBrack: {
			GetToken(ls, formula, tokens, values, token_size);
			float f = ParseAddExpr(ls, formula, tokens, values, token_size);
			if( ls.tok.tag != TokenRBrack ) {
				LogError("[VSH2 CfgEvent] :: expected ']' bracket but got '%s'", ls.tok.lexeme);
				return 0.0;
			}
			GetToken(ls, formula, tokens, values, token_size);
			return f;
		}
	}
	return 0.0;
}

bool LexOctal(LexState ls, const char[] formula)
{
	while( formula[ls.i] != 0 && (IsCharNumeric(formula[ls.i])) ) {
		switch( formula[ls.i] ) {
			case '0', '1', '2', '3', '4', '5', '6', '7': {
				ls.tok.lexeme[ls.tok.size++] = formula[ls.i++];
			}
			default: {
				ls.tok.lexeme[ls.tok.size++] = formula[ls.i++];
				LogError("[VSH2 CfgEvent] :: invalid octal literal: '%s'", ls.tok.lexeme);
				return false;
			}
		}
	}
	return true;
}

bool LexHex(LexState ls, const char[] formula)
{
	while( formula[ls.i] != 0 && (IsCharNumeric(formula[ls.i]) || IsCharAlpha(formula[ls.i])) ) {
		switch( formula[ls.i] ) {
			case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
				'a', 'b', 'c', 'd', 'e', 'f',
				'A', 'B', 'C', 'D', 'E', 'F': {
				ls.tok.lexeme[ls.tok.size++] = formula[ls.i++];
			}
			default: {
				ls.tok.lexeme[ls.tok.size++] = formula[ls.i++];
				LogError("[VSH2 CfgEvent] :: invalid hex literal: '%s'", ls.tok.lexeme);
				return false;
			}
		}
	}
	return true;
}

bool LexDec(LexState ls, const char[] formula)
{
	int lit_flags = 0;
	while( formula[ls.i] != 0 && (IsCharNumeric(formula[ls.i]) || formula[ls.i]=='.') ) {
		switch( formula[ls.i] ) {
			case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9': {
				ls.tok.lexeme[ls.tok.size++] = formula[ls.i++];
			}
			case '.': {
				if( lit_flags & dot_flag ) {
					LogError("[VSH2 CfgEvent] :: extra dot in decimal literal");
					return false;
				}
				ls.tok.lexeme[ls.tok.size++] = formula[ls.i++];
				lit_flags |= dot_flag;
			}
			default: {
				ls.tok.lexeme[ls.tok.size++] = formula[ls.i++];
				LogError("[VSH2 CfgEvent] :: invalid decimal literal: '%s'", ls.tok.lexeme);
				return false;
			}
		}
	}
	return true;
}

void GetToken(LexState ls, const char[] formula, const char[] tokens, const float[] values, int token_size)
{
	int len = strlen(formula);
	Token empty;
	ls.tok = empty;
	while( ls.i<len ) {
		switch( formula[ls.i] ) {
			case ' ', '\t', '\n': {
				ls.i++;
			}
			case '0': { /// possible hex, octal, binary, or float.
				ls.tok.tag = TokenNum;
				ls.i++;
				switch( formula[ls.i] ) {
					case 'o', 'O': {
						/// Octal.
						ls.i++;
						if( LexOctal(ls, formula) ) {
							ls.tok.val = StringToInt(ls.tok.lexeme, 8) + 0.0;
						}
						return;
					}
					case 'x', 'X': {
						/// Hex.
						ls.i++;
						if( LexHex(ls, formula) ) {
							ls.tok.val = StringToInt(ls.tok.lexeme, 16) + 0.0;
						}
						return;
					}
					case '.', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9': {
						/// Decimal/Float.
						if( LexDec(ls, formula) ) {
							ls.tok.val = StringToFloat(ls.tok.lexeme);
						}
						return;
					}
				}
			}
			case '.', '1', '2', '3', '4', '5', '6', '7', '8', '9': {
				ls.tok.tag = TokenNum;
				/// Decimal/Float.
				if( LexDec(ls, formula) ) {
					ls.tok.val = StringToFloat(ls.tok.lexeme);
				}
				return;
			}
			case '(': {
				ls.tok.lexeme[ls.tok.size++] = formula[ls.i++];
				ls.tok.tag = TokenLParen;
				return;
			}
			case ')': {
				ls.tok.lexeme[ls.tok.size++] = formula[ls.i++];
				ls.tok.tag = TokenRParen;
				return;
			}
			case '[': {
				ls.tok.lexeme[ls.tok.size++] = formula[ls.i++];
				ls.tok.tag = TokenLBrack;
				return;
			}
			case ']': {
				ls.tok.lexeme[ls.tok.size++] = formula[ls.i++];
				ls.tok.tag = TokenRBrack;
				return;
			}
			case '+': {
				ls.tok.lexeme[ls.tok.size++] = formula[ls.i++];
				ls.tok.tag = TokenPlus;
				return;
			}
			case '-': {
				ls.tok.lexeme[ls.tok.size++] = formula[ls.i++];
				ls.tok.tag = TokenSub;
				return;
			}
			case '*': {
				ls.tok.lexeme[ls.tok.size++] = formula[ls.i++];
				ls.tok.tag = TokenMul;
				return;
			}
			case '/': {
				ls.tok.lexeme[ls.tok.size++] = formula[ls.i++];
				ls.tok.tag = TokenDiv;
				return;
			}
			case '^': {
				ls.tok.lexeme[ls.tok.size++] = formula[ls.i++];
				ls.tok.tag = TokenPow;
				return;
			}
			default: {
				char tok = formula[ls.i];
				ls.tok.lexeme[ls.tok.size++] = formula[ls.i++];
				for( int i = 0; i < token_size; i++ ) {
					if( tokens[i]==tok ) {
						ls.tok.tag = TokenVar;
						ls.tok.val = values[i];
						return;
					}
				}
				LogError("[VSH2 CfgEvent] :: invalid formula token '%s'.", ls.tok.lexeme);
				return;
			}
		}
	}
}