
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Cloud Translation
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The Google Cloud Translation API lets websites and programs integrate with
##     Google Translate programmatically.
## 
## https://code.google.com/apis/language/translate/v2/getting_started.html
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "translate"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LanguageTranslationsTranslate_578890 = ref object of OpenApiRestCall_578339
proc url_LanguageTranslationsTranslate_578892(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_LanguageTranslationsTranslate_578891(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Translates input text, returning translated text.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578893 = query.getOrDefault("key")
  valid_578893 = validateParameter(valid_578893, JString, required = false,
                                 default = nil)
  if valid_578893 != nil:
    section.add "key", valid_578893
  var valid_578894 = query.getOrDefault("pp")
  valid_578894 = validateParameter(valid_578894, JBool, required = false,
                                 default = newJBool(true))
  if valid_578894 != nil:
    section.add "pp", valid_578894
  var valid_578895 = query.getOrDefault("prettyPrint")
  valid_578895 = validateParameter(valid_578895, JBool, required = false,
                                 default = newJBool(true))
  if valid_578895 != nil:
    section.add "prettyPrint", valid_578895
  var valid_578896 = query.getOrDefault("oauth_token")
  valid_578896 = validateParameter(valid_578896, JString, required = false,
                                 default = nil)
  if valid_578896 != nil:
    section.add "oauth_token", valid_578896
  var valid_578897 = query.getOrDefault("$.xgafv")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = newJString("1"))
  if valid_578897 != nil:
    section.add "$.xgafv", valid_578897
  var valid_578898 = query.getOrDefault("bearer_token")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "bearer_token", valid_578898
  var valid_578899 = query.getOrDefault("alt")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = newJString("json"))
  if valid_578899 != nil:
    section.add "alt", valid_578899
  var valid_578900 = query.getOrDefault("uploadType")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = nil)
  if valid_578900 != nil:
    section.add "uploadType", valid_578900
  var valid_578901 = query.getOrDefault("quotaUser")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "quotaUser", valid_578901
  var valid_578902 = query.getOrDefault("callback")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "callback", valid_578902
  var valid_578903 = query.getOrDefault("fields")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = nil)
  if valid_578903 != nil:
    section.add "fields", valid_578903
  var valid_578904 = query.getOrDefault("access_token")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "access_token", valid_578904
  var valid_578905 = query.getOrDefault("upload_protocol")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "upload_protocol", valid_578905
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578907: Call_LanguageTranslationsTranslate_578890; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Translates input text, returning translated text.
  ## 
  let valid = call_578907.validator(path, query, header, formData, body)
  let scheme = call_578907.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578907.url(scheme.get, call_578907.host, call_578907.base,
                         call_578907.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578907, url, valid)

proc call*(call_578908: Call_LanguageTranslationsTranslate_578890;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## languageTranslationsTranslate
  ## Translates input text, returning translated text.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578909 = newJObject()
  var body_578910 = newJObject()
  add(query_578909, "key", newJString(key))
  add(query_578909, "pp", newJBool(pp))
  add(query_578909, "prettyPrint", newJBool(prettyPrint))
  add(query_578909, "oauth_token", newJString(oauthToken))
  add(query_578909, "$.xgafv", newJString(Xgafv))
  add(query_578909, "bearer_token", newJString(bearerToken))
  add(query_578909, "alt", newJString(alt))
  add(query_578909, "uploadType", newJString(uploadType))
  add(query_578909, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578910 = body
  add(query_578909, "callback", newJString(callback))
  add(query_578909, "fields", newJString(fields))
  add(query_578909, "access_token", newJString(accessToken))
  add(query_578909, "upload_protocol", newJString(uploadProtocol))
  result = call_578908.call(nil, query_578909, nil, nil, body_578910)

var languageTranslationsTranslate* = Call_LanguageTranslationsTranslate_578890(
    name: "languageTranslationsTranslate", meth: HttpMethod.HttpPost,
    host: "translation.googleapis.com", route: "/v2",
    validator: validate_LanguageTranslationsTranslate_578891,
    base: "/language/translate", url: url_LanguageTranslationsTranslate_578892,
    schemes: {Scheme.Https})
type
  Call_LanguageTranslationsList_578610 = ref object of OpenApiRestCall_578339
proc url_LanguageTranslationsList_578612(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_LanguageTranslationsList_578611(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Translates input text, returning translated text.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   model: JString
  ##        : The `model` type requested for this translation. Valid values are
  ## listed in public documentation.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   target: JString (required)
  ##         : The language to use for translation of the input text, set to one of the
  ## language codes listed in Language Support.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   q: JArray (required)
  ##    : The input text to translate. Repeat this parameter to perform translation
  ## operations on multiple text inputs.
  ##   source: JString
  ##         : The language of the source text, set to one of the language codes listed in
  ## Language Support. If the source language is not specified, the API will
  ## attempt to identify the source language automatically and return it within
  ## the response.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   callback: JString
  ##           : JSONP
  ##   cid: JArray
  ##      : The customization id for translate
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   format: JString
  ##         : The format of the source text, in either HTML (default) or plain-text. A
  ## value of "html" indicates HTML and a value of "text" indicates plain-text.
  section = newJObject()
  var valid_578724 = query.getOrDefault("key")
  valid_578724 = validateParameter(valid_578724, JString, required = false,
                                 default = nil)
  if valid_578724 != nil:
    section.add "key", valid_578724
  var valid_578738 = query.getOrDefault("pp")
  valid_578738 = validateParameter(valid_578738, JBool, required = false,
                                 default = newJBool(true))
  if valid_578738 != nil:
    section.add "pp", valid_578738
  var valid_578739 = query.getOrDefault("prettyPrint")
  valid_578739 = validateParameter(valid_578739, JBool, required = false,
                                 default = newJBool(true))
  if valid_578739 != nil:
    section.add "prettyPrint", valid_578739
  var valid_578740 = query.getOrDefault("oauth_token")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = nil)
  if valid_578740 != nil:
    section.add "oauth_token", valid_578740
  var valid_578741 = query.getOrDefault("model")
  valid_578741 = validateParameter(valid_578741, JString, required = false,
                                 default = nil)
  if valid_578741 != nil:
    section.add "model", valid_578741
  var valid_578742 = query.getOrDefault("$.xgafv")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = newJString("1"))
  if valid_578742 != nil:
    section.add "$.xgafv", valid_578742
  assert query != nil, "query argument is necessary due to required `target` field"
  var valid_578743 = query.getOrDefault("target")
  valid_578743 = validateParameter(valid_578743, JString, required = true,
                                 default = nil)
  if valid_578743 != nil:
    section.add "target", valid_578743
  var valid_578744 = query.getOrDefault("bearer_token")
  valid_578744 = validateParameter(valid_578744, JString, required = false,
                                 default = nil)
  if valid_578744 != nil:
    section.add "bearer_token", valid_578744
  var valid_578745 = query.getOrDefault("q")
  valid_578745 = validateParameter(valid_578745, JArray, required = true, default = nil)
  if valid_578745 != nil:
    section.add "q", valid_578745
  var valid_578746 = query.getOrDefault("source")
  valid_578746 = validateParameter(valid_578746, JString, required = false,
                                 default = nil)
  if valid_578746 != nil:
    section.add "source", valid_578746
  var valid_578747 = query.getOrDefault("alt")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = newJString("json"))
  if valid_578747 != nil:
    section.add "alt", valid_578747
  var valid_578748 = query.getOrDefault("uploadType")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "uploadType", valid_578748
  var valid_578749 = query.getOrDefault("quotaUser")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "quotaUser", valid_578749
  var valid_578750 = query.getOrDefault("callback")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = nil)
  if valid_578750 != nil:
    section.add "callback", valid_578750
  var valid_578751 = query.getOrDefault("cid")
  valid_578751 = validateParameter(valid_578751, JArray, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "cid", valid_578751
  var valid_578752 = query.getOrDefault("fields")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = nil)
  if valid_578752 != nil:
    section.add "fields", valid_578752
  var valid_578753 = query.getOrDefault("access_token")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "access_token", valid_578753
  var valid_578754 = query.getOrDefault("upload_protocol")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "upload_protocol", valid_578754
  var valid_578755 = query.getOrDefault("format")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("html"))
  if valid_578755 != nil:
    section.add "format", valid_578755
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578778: Call_LanguageTranslationsList_578610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Translates input text, returning translated text.
  ## 
  let valid = call_578778.validator(path, query, header, formData, body)
  let scheme = call_578778.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578778.url(scheme.get, call_578778.host, call_578778.base,
                         call_578778.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578778, url, valid)

proc call*(call_578849: Call_LanguageTranslationsList_578610; target: string;
          q: JsonNode; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; model: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; source: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          cid: JsonNode = nil; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; format: string = "html"): Recallable =
  ## languageTranslationsList
  ## Translates input text, returning translated text.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   model: string
  ##        : The `model` type requested for this translation. Valid values are
  ## listed in public documentation.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   target: string (required)
  ##         : The language to use for translation of the input text, set to one of the
  ## language codes listed in Language Support.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   q: JArray (required)
  ##    : The input text to translate. Repeat this parameter to perform translation
  ## operations on multiple text inputs.
  ##   source: string
  ##         : The language of the source text, set to one of the language codes listed in
  ## Language Support. If the source language is not specified, the API will
  ## attempt to identify the source language automatically and return it within
  ## the response.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   callback: string
  ##           : JSONP
  ##   cid: JArray
  ##      : The customization id for translate
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   format: string
  ##         : The format of the source text, in either HTML (default) or plain-text. A
  ## value of "html" indicates HTML and a value of "text" indicates plain-text.
  var query_578850 = newJObject()
  add(query_578850, "key", newJString(key))
  add(query_578850, "pp", newJBool(pp))
  add(query_578850, "prettyPrint", newJBool(prettyPrint))
  add(query_578850, "oauth_token", newJString(oauthToken))
  add(query_578850, "model", newJString(model))
  add(query_578850, "$.xgafv", newJString(Xgafv))
  add(query_578850, "target", newJString(target))
  add(query_578850, "bearer_token", newJString(bearerToken))
  if q != nil:
    query_578850.add "q", q
  add(query_578850, "source", newJString(source))
  add(query_578850, "alt", newJString(alt))
  add(query_578850, "uploadType", newJString(uploadType))
  add(query_578850, "quotaUser", newJString(quotaUser))
  add(query_578850, "callback", newJString(callback))
  if cid != nil:
    query_578850.add "cid", cid
  add(query_578850, "fields", newJString(fields))
  add(query_578850, "access_token", newJString(accessToken))
  add(query_578850, "upload_protocol", newJString(uploadProtocol))
  add(query_578850, "format", newJString(format))
  result = call_578849.call(nil, query_578850, nil, nil, nil)

var languageTranslationsList* = Call_LanguageTranslationsList_578610(
    name: "languageTranslationsList", meth: HttpMethod.HttpGet,
    host: "translation.googleapis.com", route: "/v2",
    validator: validate_LanguageTranslationsList_578611,
    base: "/language/translate", url: url_LanguageTranslationsList_578612,
    schemes: {Scheme.Https})
type
  Call_LanguageDetectionsDetect_578931 = ref object of OpenApiRestCall_578339
proc url_LanguageDetectionsDetect_578933(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_LanguageDetectionsDetect_578932(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Detects the language of text within a request.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578934 = query.getOrDefault("key")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "key", valid_578934
  var valid_578935 = query.getOrDefault("pp")
  valid_578935 = validateParameter(valid_578935, JBool, required = false,
                                 default = newJBool(true))
  if valid_578935 != nil:
    section.add "pp", valid_578935
  var valid_578936 = query.getOrDefault("prettyPrint")
  valid_578936 = validateParameter(valid_578936, JBool, required = false,
                                 default = newJBool(true))
  if valid_578936 != nil:
    section.add "prettyPrint", valid_578936
  var valid_578937 = query.getOrDefault("oauth_token")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "oauth_token", valid_578937
  var valid_578938 = query.getOrDefault("$.xgafv")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = newJString("1"))
  if valid_578938 != nil:
    section.add "$.xgafv", valid_578938
  var valid_578939 = query.getOrDefault("bearer_token")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "bearer_token", valid_578939
  var valid_578940 = query.getOrDefault("alt")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = newJString("json"))
  if valid_578940 != nil:
    section.add "alt", valid_578940
  var valid_578941 = query.getOrDefault("uploadType")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "uploadType", valid_578941
  var valid_578942 = query.getOrDefault("quotaUser")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "quotaUser", valid_578942
  var valid_578943 = query.getOrDefault("callback")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "callback", valid_578943
  var valid_578944 = query.getOrDefault("fields")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "fields", valid_578944
  var valid_578945 = query.getOrDefault("access_token")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "access_token", valid_578945
  var valid_578946 = query.getOrDefault("upload_protocol")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "upload_protocol", valid_578946
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578948: Call_LanguageDetectionsDetect_578931; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detects the language of text within a request.
  ## 
  let valid = call_578948.validator(path, query, header, formData, body)
  let scheme = call_578948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578948.url(scheme.get, call_578948.host, call_578948.base,
                         call_578948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578948, url, valid)

proc call*(call_578949: Call_LanguageDetectionsDetect_578931; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## languageDetectionsDetect
  ## Detects the language of text within a request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578950 = newJObject()
  var body_578951 = newJObject()
  add(query_578950, "key", newJString(key))
  add(query_578950, "pp", newJBool(pp))
  add(query_578950, "prettyPrint", newJBool(prettyPrint))
  add(query_578950, "oauth_token", newJString(oauthToken))
  add(query_578950, "$.xgafv", newJString(Xgafv))
  add(query_578950, "bearer_token", newJString(bearerToken))
  add(query_578950, "alt", newJString(alt))
  add(query_578950, "uploadType", newJString(uploadType))
  add(query_578950, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578951 = body
  add(query_578950, "callback", newJString(callback))
  add(query_578950, "fields", newJString(fields))
  add(query_578950, "access_token", newJString(accessToken))
  add(query_578950, "upload_protocol", newJString(uploadProtocol))
  result = call_578949.call(nil, query_578950, nil, nil, body_578951)

var languageDetectionsDetect* = Call_LanguageDetectionsDetect_578931(
    name: "languageDetectionsDetect", meth: HttpMethod.HttpPost,
    host: "translation.googleapis.com", route: "/v2/detect",
    validator: validate_LanguageDetectionsDetect_578932,
    base: "/language/translate", url: url_LanguageDetectionsDetect_578933,
    schemes: {Scheme.Https})
type
  Call_LanguageDetectionsList_578911 = ref object of OpenApiRestCall_578339
proc url_LanguageDetectionsList_578913(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_LanguageDetectionsList_578912(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Detects the language of text within a request.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   q: JArray (required)
  ##    : The input text upon which to perform language detection. Repeat this
  ## parameter to perform language detection on multiple text inputs.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578914 = query.getOrDefault("key")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "key", valid_578914
  var valid_578915 = query.getOrDefault("pp")
  valid_578915 = validateParameter(valid_578915, JBool, required = false,
                                 default = newJBool(true))
  if valid_578915 != nil:
    section.add "pp", valid_578915
  var valid_578916 = query.getOrDefault("prettyPrint")
  valid_578916 = validateParameter(valid_578916, JBool, required = false,
                                 default = newJBool(true))
  if valid_578916 != nil:
    section.add "prettyPrint", valid_578916
  var valid_578917 = query.getOrDefault("oauth_token")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "oauth_token", valid_578917
  var valid_578918 = query.getOrDefault("$.xgafv")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = newJString("1"))
  if valid_578918 != nil:
    section.add "$.xgafv", valid_578918
  var valid_578919 = query.getOrDefault("bearer_token")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "bearer_token", valid_578919
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_578920 = query.getOrDefault("q")
  valid_578920 = validateParameter(valid_578920, JArray, required = true, default = nil)
  if valid_578920 != nil:
    section.add "q", valid_578920
  var valid_578921 = query.getOrDefault("alt")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = newJString("json"))
  if valid_578921 != nil:
    section.add "alt", valid_578921
  var valid_578922 = query.getOrDefault("uploadType")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "uploadType", valid_578922
  var valid_578923 = query.getOrDefault("quotaUser")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "quotaUser", valid_578923
  var valid_578924 = query.getOrDefault("callback")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "callback", valid_578924
  var valid_578925 = query.getOrDefault("fields")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "fields", valid_578925
  var valid_578926 = query.getOrDefault("access_token")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "access_token", valid_578926
  var valid_578927 = query.getOrDefault("upload_protocol")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "upload_protocol", valid_578927
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578928: Call_LanguageDetectionsList_578911; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detects the language of text within a request.
  ## 
  let valid = call_578928.validator(path, query, header, formData, body)
  let scheme = call_578928.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578928.url(scheme.get, call_578928.host, call_578928.base,
                         call_578928.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578928, url, valid)

proc call*(call_578929: Call_LanguageDetectionsList_578911; q: JsonNode;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## languageDetectionsList
  ## Detects the language of text within a request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   q: JArray (required)
  ##    : The input text upon which to perform language detection. Repeat this
  ## parameter to perform language detection on multiple text inputs.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578930 = newJObject()
  add(query_578930, "key", newJString(key))
  add(query_578930, "pp", newJBool(pp))
  add(query_578930, "prettyPrint", newJBool(prettyPrint))
  add(query_578930, "oauth_token", newJString(oauthToken))
  add(query_578930, "$.xgafv", newJString(Xgafv))
  add(query_578930, "bearer_token", newJString(bearerToken))
  if q != nil:
    query_578930.add "q", q
  add(query_578930, "alt", newJString(alt))
  add(query_578930, "uploadType", newJString(uploadType))
  add(query_578930, "quotaUser", newJString(quotaUser))
  add(query_578930, "callback", newJString(callback))
  add(query_578930, "fields", newJString(fields))
  add(query_578930, "access_token", newJString(accessToken))
  add(query_578930, "upload_protocol", newJString(uploadProtocol))
  result = call_578929.call(nil, query_578930, nil, nil, nil)

var languageDetectionsList* = Call_LanguageDetectionsList_578911(
    name: "languageDetectionsList", meth: HttpMethod.HttpGet,
    host: "translation.googleapis.com", route: "/v2/detect",
    validator: validate_LanguageDetectionsList_578912,
    base: "/language/translate", url: url_LanguageDetectionsList_578913,
    schemes: {Scheme.Https})
type
  Call_LanguageLanguagesList_578952 = ref object of OpenApiRestCall_578339
proc url_LanguageLanguagesList_578954(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_LanguageLanguagesList_578953(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of supported languages for translation.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   model: JString
  ##        : The model type for which supported languages should be returned.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   target: JString
  ##         : The language to use to return localized, human readable names of supported
  ## languages.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578955 = query.getOrDefault("key")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "key", valid_578955
  var valid_578956 = query.getOrDefault("pp")
  valid_578956 = validateParameter(valid_578956, JBool, required = false,
                                 default = newJBool(true))
  if valid_578956 != nil:
    section.add "pp", valid_578956
  var valid_578957 = query.getOrDefault("prettyPrint")
  valid_578957 = validateParameter(valid_578957, JBool, required = false,
                                 default = newJBool(true))
  if valid_578957 != nil:
    section.add "prettyPrint", valid_578957
  var valid_578958 = query.getOrDefault("oauth_token")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "oauth_token", valid_578958
  var valid_578959 = query.getOrDefault("model")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "model", valid_578959
  var valid_578960 = query.getOrDefault("$.xgafv")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = newJString("1"))
  if valid_578960 != nil:
    section.add "$.xgafv", valid_578960
  var valid_578961 = query.getOrDefault("target")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "target", valid_578961
  var valid_578962 = query.getOrDefault("bearer_token")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "bearer_token", valid_578962
  var valid_578963 = query.getOrDefault("alt")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = newJString("json"))
  if valid_578963 != nil:
    section.add "alt", valid_578963
  var valid_578964 = query.getOrDefault("uploadType")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "uploadType", valid_578964
  var valid_578965 = query.getOrDefault("quotaUser")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "quotaUser", valid_578965
  var valid_578966 = query.getOrDefault("callback")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "callback", valid_578966
  var valid_578967 = query.getOrDefault("fields")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "fields", valid_578967
  var valid_578968 = query.getOrDefault("access_token")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "access_token", valid_578968
  var valid_578969 = query.getOrDefault("upload_protocol")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "upload_protocol", valid_578969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578970: Call_LanguageLanguagesList_578952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of supported languages for translation.
  ## 
  let valid = call_578970.validator(path, query, header, formData, body)
  let scheme = call_578970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578970.url(scheme.get, call_578970.host, call_578970.base,
                         call_578970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578970, url, valid)

proc call*(call_578971: Call_LanguageLanguagesList_578952; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          model: string = ""; Xgafv: string = "1"; target: string = "";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## languageLanguagesList
  ## Returns a list of supported languages for translation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   model: string
  ##        : The model type for which supported languages should be returned.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   target: string
  ##         : The language to use to return localized, human readable names of supported
  ## languages.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578972 = newJObject()
  add(query_578972, "key", newJString(key))
  add(query_578972, "pp", newJBool(pp))
  add(query_578972, "prettyPrint", newJBool(prettyPrint))
  add(query_578972, "oauth_token", newJString(oauthToken))
  add(query_578972, "model", newJString(model))
  add(query_578972, "$.xgafv", newJString(Xgafv))
  add(query_578972, "target", newJString(target))
  add(query_578972, "bearer_token", newJString(bearerToken))
  add(query_578972, "alt", newJString(alt))
  add(query_578972, "uploadType", newJString(uploadType))
  add(query_578972, "quotaUser", newJString(quotaUser))
  add(query_578972, "callback", newJString(callback))
  add(query_578972, "fields", newJString(fields))
  add(query_578972, "access_token", newJString(accessToken))
  add(query_578972, "upload_protocol", newJString(uploadProtocol))
  result = call_578971.call(nil, query_578972, nil, nil, nil)

var languageLanguagesList* = Call_LanguageLanguagesList_578952(
    name: "languageLanguagesList", meth: HttpMethod.HttpGet,
    host: "translation.googleapis.com", route: "/v2/languages",
    validator: validate_LanguageLanguagesList_578953, base: "/language/translate",
    url: url_LanguageLanguagesList_578954, schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
