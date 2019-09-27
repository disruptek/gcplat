
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "translate"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LanguageTranslationsTranslate_593957 = ref object of OpenApiRestCall_593408
proc url_LanguageTranslationsTranslate_593959(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LanguageTranslationsTranslate_593958(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Translates input text, returning translated text.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_593960 = query.getOrDefault("upload_protocol")
  valid_593960 = validateParameter(valid_593960, JString, required = false,
                                 default = nil)
  if valid_593960 != nil:
    section.add "upload_protocol", valid_593960
  var valid_593961 = query.getOrDefault("fields")
  valid_593961 = validateParameter(valid_593961, JString, required = false,
                                 default = nil)
  if valid_593961 != nil:
    section.add "fields", valid_593961
  var valid_593962 = query.getOrDefault("quotaUser")
  valid_593962 = validateParameter(valid_593962, JString, required = false,
                                 default = nil)
  if valid_593962 != nil:
    section.add "quotaUser", valid_593962
  var valid_593963 = query.getOrDefault("alt")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = newJString("json"))
  if valid_593963 != nil:
    section.add "alt", valid_593963
  var valid_593964 = query.getOrDefault("pp")
  valid_593964 = validateParameter(valid_593964, JBool, required = false,
                                 default = newJBool(true))
  if valid_593964 != nil:
    section.add "pp", valid_593964
  var valid_593965 = query.getOrDefault("oauth_token")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "oauth_token", valid_593965
  var valid_593966 = query.getOrDefault("callback")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = nil)
  if valid_593966 != nil:
    section.add "callback", valid_593966
  var valid_593967 = query.getOrDefault("access_token")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "access_token", valid_593967
  var valid_593968 = query.getOrDefault("uploadType")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = nil)
  if valid_593968 != nil:
    section.add "uploadType", valid_593968
  var valid_593969 = query.getOrDefault("key")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "key", valid_593969
  var valid_593970 = query.getOrDefault("$.xgafv")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = newJString("1"))
  if valid_593970 != nil:
    section.add "$.xgafv", valid_593970
  var valid_593971 = query.getOrDefault("prettyPrint")
  valid_593971 = validateParameter(valid_593971, JBool, required = false,
                                 default = newJBool(true))
  if valid_593971 != nil:
    section.add "prettyPrint", valid_593971
  var valid_593972 = query.getOrDefault("bearer_token")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = nil)
  if valid_593972 != nil:
    section.add "bearer_token", valid_593972
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

proc call*(call_593974: Call_LanguageTranslationsTranslate_593957; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Translates input text, returning translated text.
  ## 
  let valid = call_593974.validator(path, query, header, formData, body)
  let scheme = call_593974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593974.url(scheme.get, call_593974.host, call_593974.base,
                         call_593974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593974, url, valid)

proc call*(call_593975: Call_LanguageTranslationsTranslate_593957;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## languageTranslationsTranslate
  ## Translates input text, returning translated text.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_593976 = newJObject()
  var body_593977 = newJObject()
  add(query_593976, "upload_protocol", newJString(uploadProtocol))
  add(query_593976, "fields", newJString(fields))
  add(query_593976, "quotaUser", newJString(quotaUser))
  add(query_593976, "alt", newJString(alt))
  add(query_593976, "pp", newJBool(pp))
  add(query_593976, "oauth_token", newJString(oauthToken))
  add(query_593976, "callback", newJString(callback))
  add(query_593976, "access_token", newJString(accessToken))
  add(query_593976, "uploadType", newJString(uploadType))
  add(query_593976, "key", newJString(key))
  add(query_593976, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593977 = body
  add(query_593976, "prettyPrint", newJBool(prettyPrint))
  add(query_593976, "bearer_token", newJString(bearerToken))
  result = call_593975.call(nil, query_593976, nil, nil, body_593977)

var languageTranslationsTranslate* = Call_LanguageTranslationsTranslate_593957(
    name: "languageTranslationsTranslate", meth: HttpMethod.HttpPost,
    host: "translation.googleapis.com", route: "/v2",
    validator: validate_LanguageTranslationsTranslate_593958,
    base: "/language/translate", url: url_LanguageTranslationsTranslate_593959,
    schemes: {Scheme.Https})
type
  Call_LanguageTranslationsList_593677 = ref object of OpenApiRestCall_593408
proc url_LanguageTranslationsList_593679(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LanguageTranslationsList_593678(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Translates input text, returning translated text.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   cid: JArray
  ##      : The customization id for translate
  ##   target: JString (required)
  ##         : The language to use for translation of the input text, set to one of the
  ## language codes listed in Language Support.
  ##   model: JString
  ##        : The `model` type requested for this translation. Valid values are
  ## listed in public documentation.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   source: JString
  ##         : The language of the source text, set to one of the language codes listed in
  ## Language Support. If the source language is not specified, the API will
  ## attempt to identify the source language automatically and return it within
  ## the response.
  ##   q: JArray (required)
  ##    : The input text to translate. Repeat this parameter to perform translation
  ## operations on multiple text inputs.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   format: JString
  ##         : The format of the source text, in either HTML (default) or plain-text. A
  ## value of "html" indicates HTML and a value of "text" indicates plain-text.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_593791 = query.getOrDefault("upload_protocol")
  valid_593791 = validateParameter(valid_593791, JString, required = false,
                                 default = nil)
  if valid_593791 != nil:
    section.add "upload_protocol", valid_593791
  var valid_593792 = query.getOrDefault("fields")
  valid_593792 = validateParameter(valid_593792, JString, required = false,
                                 default = nil)
  if valid_593792 != nil:
    section.add "fields", valid_593792
  var valid_593793 = query.getOrDefault("quotaUser")
  valid_593793 = validateParameter(valid_593793, JString, required = false,
                                 default = nil)
  if valid_593793 != nil:
    section.add "quotaUser", valid_593793
  var valid_593807 = query.getOrDefault("alt")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = newJString("json"))
  if valid_593807 != nil:
    section.add "alt", valid_593807
  var valid_593808 = query.getOrDefault("pp")
  valid_593808 = validateParameter(valid_593808, JBool, required = false,
                                 default = newJBool(true))
  if valid_593808 != nil:
    section.add "pp", valid_593808
  var valid_593809 = query.getOrDefault("cid")
  valid_593809 = validateParameter(valid_593809, JArray, required = false,
                                 default = nil)
  if valid_593809 != nil:
    section.add "cid", valid_593809
  assert query != nil, "query argument is necessary due to required `target` field"
  var valid_593810 = query.getOrDefault("target")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "target", valid_593810
  var valid_593811 = query.getOrDefault("model")
  valid_593811 = validateParameter(valid_593811, JString, required = false,
                                 default = nil)
  if valid_593811 != nil:
    section.add "model", valid_593811
  var valid_593812 = query.getOrDefault("oauth_token")
  valid_593812 = validateParameter(valid_593812, JString, required = false,
                                 default = nil)
  if valid_593812 != nil:
    section.add "oauth_token", valid_593812
  var valid_593813 = query.getOrDefault("callback")
  valid_593813 = validateParameter(valid_593813, JString, required = false,
                                 default = nil)
  if valid_593813 != nil:
    section.add "callback", valid_593813
  var valid_593814 = query.getOrDefault("access_token")
  valid_593814 = validateParameter(valid_593814, JString, required = false,
                                 default = nil)
  if valid_593814 != nil:
    section.add "access_token", valid_593814
  var valid_593815 = query.getOrDefault("uploadType")
  valid_593815 = validateParameter(valid_593815, JString, required = false,
                                 default = nil)
  if valid_593815 != nil:
    section.add "uploadType", valid_593815
  var valid_593816 = query.getOrDefault("source")
  valid_593816 = validateParameter(valid_593816, JString, required = false,
                                 default = nil)
  if valid_593816 != nil:
    section.add "source", valid_593816
  var valid_593817 = query.getOrDefault("q")
  valid_593817 = validateParameter(valid_593817, JArray, required = true, default = nil)
  if valid_593817 != nil:
    section.add "q", valid_593817
  var valid_593818 = query.getOrDefault("key")
  valid_593818 = validateParameter(valid_593818, JString, required = false,
                                 default = nil)
  if valid_593818 != nil:
    section.add "key", valid_593818
  var valid_593819 = query.getOrDefault("$.xgafv")
  valid_593819 = validateParameter(valid_593819, JString, required = false,
                                 default = newJString("1"))
  if valid_593819 != nil:
    section.add "$.xgafv", valid_593819
  var valid_593820 = query.getOrDefault("prettyPrint")
  valid_593820 = validateParameter(valid_593820, JBool, required = false,
                                 default = newJBool(true))
  if valid_593820 != nil:
    section.add "prettyPrint", valid_593820
  var valid_593821 = query.getOrDefault("format")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = newJString("html"))
  if valid_593821 != nil:
    section.add "format", valid_593821
  var valid_593822 = query.getOrDefault("bearer_token")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "bearer_token", valid_593822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593845: Call_LanguageTranslationsList_593677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Translates input text, returning translated text.
  ## 
  let valid = call_593845.validator(path, query, header, formData, body)
  let scheme = call_593845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593845.url(scheme.get, call_593845.host, call_593845.base,
                         call_593845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593845, url, valid)

proc call*(call_593916: Call_LanguageTranslationsList_593677; target: string;
          q: JsonNode; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          cid: JsonNode = nil; model: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          source: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; format: string = "html"; bearerToken: string = ""): Recallable =
  ## languageTranslationsList
  ## Translates input text, returning translated text.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   cid: JArray
  ##      : The customization id for translate
  ##   target: string (required)
  ##         : The language to use for translation of the input text, set to one of the
  ## language codes listed in Language Support.
  ##   model: string
  ##        : The `model` type requested for this translation. Valid values are
  ## listed in public documentation.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   source: string
  ##         : The language of the source text, set to one of the language codes listed in
  ## Language Support. If the source language is not specified, the API will
  ## attempt to identify the source language automatically and return it within
  ## the response.
  ##   q: JArray (required)
  ##    : The input text to translate. Repeat this parameter to perform translation
  ## operations on multiple text inputs.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   format: string
  ##         : The format of the source text, in either HTML (default) or plain-text. A
  ## value of "html" indicates HTML and a value of "text" indicates plain-text.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_593917 = newJObject()
  add(query_593917, "upload_protocol", newJString(uploadProtocol))
  add(query_593917, "fields", newJString(fields))
  add(query_593917, "quotaUser", newJString(quotaUser))
  add(query_593917, "alt", newJString(alt))
  add(query_593917, "pp", newJBool(pp))
  if cid != nil:
    query_593917.add "cid", cid
  add(query_593917, "target", newJString(target))
  add(query_593917, "model", newJString(model))
  add(query_593917, "oauth_token", newJString(oauthToken))
  add(query_593917, "callback", newJString(callback))
  add(query_593917, "access_token", newJString(accessToken))
  add(query_593917, "uploadType", newJString(uploadType))
  add(query_593917, "source", newJString(source))
  if q != nil:
    query_593917.add "q", q
  add(query_593917, "key", newJString(key))
  add(query_593917, "$.xgafv", newJString(Xgafv))
  add(query_593917, "prettyPrint", newJBool(prettyPrint))
  add(query_593917, "format", newJString(format))
  add(query_593917, "bearer_token", newJString(bearerToken))
  result = call_593916.call(nil, query_593917, nil, nil, nil)

var languageTranslationsList* = Call_LanguageTranslationsList_593677(
    name: "languageTranslationsList", meth: HttpMethod.HttpGet,
    host: "translation.googleapis.com", route: "/v2",
    validator: validate_LanguageTranslationsList_593678,
    base: "/language/translate", url: url_LanguageTranslationsList_593679,
    schemes: {Scheme.Https})
type
  Call_LanguageDetectionsDetect_593998 = ref object of OpenApiRestCall_593408
proc url_LanguageDetectionsDetect_594000(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LanguageDetectionsDetect_593999(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Detects the language of text within a request.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_594001 = query.getOrDefault("upload_protocol")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "upload_protocol", valid_594001
  var valid_594002 = query.getOrDefault("fields")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "fields", valid_594002
  var valid_594003 = query.getOrDefault("quotaUser")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "quotaUser", valid_594003
  var valid_594004 = query.getOrDefault("alt")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = newJString("json"))
  if valid_594004 != nil:
    section.add "alt", valid_594004
  var valid_594005 = query.getOrDefault("pp")
  valid_594005 = validateParameter(valid_594005, JBool, required = false,
                                 default = newJBool(true))
  if valid_594005 != nil:
    section.add "pp", valid_594005
  var valid_594006 = query.getOrDefault("oauth_token")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "oauth_token", valid_594006
  var valid_594007 = query.getOrDefault("callback")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "callback", valid_594007
  var valid_594008 = query.getOrDefault("access_token")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "access_token", valid_594008
  var valid_594009 = query.getOrDefault("uploadType")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "uploadType", valid_594009
  var valid_594010 = query.getOrDefault("key")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "key", valid_594010
  var valid_594011 = query.getOrDefault("$.xgafv")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = newJString("1"))
  if valid_594011 != nil:
    section.add "$.xgafv", valid_594011
  var valid_594012 = query.getOrDefault("prettyPrint")
  valid_594012 = validateParameter(valid_594012, JBool, required = false,
                                 default = newJBool(true))
  if valid_594012 != nil:
    section.add "prettyPrint", valid_594012
  var valid_594013 = query.getOrDefault("bearer_token")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "bearer_token", valid_594013
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

proc call*(call_594015: Call_LanguageDetectionsDetect_593998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detects the language of text within a request.
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_LanguageDetectionsDetect_593998;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## languageDetectionsDetect
  ## Detects the language of text within a request.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_594017 = newJObject()
  var body_594018 = newJObject()
  add(query_594017, "upload_protocol", newJString(uploadProtocol))
  add(query_594017, "fields", newJString(fields))
  add(query_594017, "quotaUser", newJString(quotaUser))
  add(query_594017, "alt", newJString(alt))
  add(query_594017, "pp", newJBool(pp))
  add(query_594017, "oauth_token", newJString(oauthToken))
  add(query_594017, "callback", newJString(callback))
  add(query_594017, "access_token", newJString(accessToken))
  add(query_594017, "uploadType", newJString(uploadType))
  add(query_594017, "key", newJString(key))
  add(query_594017, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594018 = body
  add(query_594017, "prettyPrint", newJBool(prettyPrint))
  add(query_594017, "bearer_token", newJString(bearerToken))
  result = call_594016.call(nil, query_594017, nil, nil, body_594018)

var languageDetectionsDetect* = Call_LanguageDetectionsDetect_593998(
    name: "languageDetectionsDetect", meth: HttpMethod.HttpPost,
    host: "translation.googleapis.com", route: "/v2/detect",
    validator: validate_LanguageDetectionsDetect_593999,
    base: "/language/translate", url: url_LanguageDetectionsDetect_594000,
    schemes: {Scheme.Https})
type
  Call_LanguageDetectionsList_593978 = ref object of OpenApiRestCall_593408
proc url_LanguageDetectionsList_593980(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LanguageDetectionsList_593979(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Detects the language of text within a request.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   q: JArray (required)
  ##    : The input text upon which to perform language detection. Repeat this
  ## parameter to perform language detection on multiple text inputs.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_593981 = query.getOrDefault("upload_protocol")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "upload_protocol", valid_593981
  var valid_593982 = query.getOrDefault("fields")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "fields", valid_593982
  var valid_593983 = query.getOrDefault("quotaUser")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "quotaUser", valid_593983
  var valid_593984 = query.getOrDefault("alt")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = newJString("json"))
  if valid_593984 != nil:
    section.add "alt", valid_593984
  var valid_593985 = query.getOrDefault("pp")
  valid_593985 = validateParameter(valid_593985, JBool, required = false,
                                 default = newJBool(true))
  if valid_593985 != nil:
    section.add "pp", valid_593985
  var valid_593986 = query.getOrDefault("oauth_token")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "oauth_token", valid_593986
  var valid_593987 = query.getOrDefault("callback")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "callback", valid_593987
  var valid_593988 = query.getOrDefault("access_token")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "access_token", valid_593988
  var valid_593989 = query.getOrDefault("uploadType")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "uploadType", valid_593989
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_593990 = query.getOrDefault("q")
  valid_593990 = validateParameter(valid_593990, JArray, required = true, default = nil)
  if valid_593990 != nil:
    section.add "q", valid_593990
  var valid_593991 = query.getOrDefault("key")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "key", valid_593991
  var valid_593992 = query.getOrDefault("$.xgafv")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = newJString("1"))
  if valid_593992 != nil:
    section.add "$.xgafv", valid_593992
  var valid_593993 = query.getOrDefault("prettyPrint")
  valid_593993 = validateParameter(valid_593993, JBool, required = false,
                                 default = newJBool(true))
  if valid_593993 != nil:
    section.add "prettyPrint", valid_593993
  var valid_593994 = query.getOrDefault("bearer_token")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "bearer_token", valid_593994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593995: Call_LanguageDetectionsList_593978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detects the language of text within a request.
  ## 
  let valid = call_593995.validator(path, query, header, formData, body)
  let scheme = call_593995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593995.url(scheme.get, call_593995.host, call_593995.base,
                         call_593995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593995, url, valid)

proc call*(call_593996: Call_LanguageDetectionsList_593978; q: JsonNode;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## languageDetectionsList
  ## Detects the language of text within a request.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   q: JArray (required)
  ##    : The input text upon which to perform language detection. Repeat this
  ## parameter to perform language detection on multiple text inputs.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_593997 = newJObject()
  add(query_593997, "upload_protocol", newJString(uploadProtocol))
  add(query_593997, "fields", newJString(fields))
  add(query_593997, "quotaUser", newJString(quotaUser))
  add(query_593997, "alt", newJString(alt))
  add(query_593997, "pp", newJBool(pp))
  add(query_593997, "oauth_token", newJString(oauthToken))
  add(query_593997, "callback", newJString(callback))
  add(query_593997, "access_token", newJString(accessToken))
  add(query_593997, "uploadType", newJString(uploadType))
  if q != nil:
    query_593997.add "q", q
  add(query_593997, "key", newJString(key))
  add(query_593997, "$.xgafv", newJString(Xgafv))
  add(query_593997, "prettyPrint", newJBool(prettyPrint))
  add(query_593997, "bearer_token", newJString(bearerToken))
  result = call_593996.call(nil, query_593997, nil, nil, nil)

var languageDetectionsList* = Call_LanguageDetectionsList_593978(
    name: "languageDetectionsList", meth: HttpMethod.HttpGet,
    host: "translation.googleapis.com", route: "/v2/detect",
    validator: validate_LanguageDetectionsList_593979,
    base: "/language/translate", url: url_LanguageDetectionsList_593980,
    schemes: {Scheme.Https})
type
  Call_LanguageLanguagesList_594019 = ref object of OpenApiRestCall_593408
proc url_LanguageLanguagesList_594021(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LanguageLanguagesList_594020(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of supported languages for translation.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   target: JString
  ##         : The language to use to return localized, human readable names of supported
  ## languages.
  ##   model: JString
  ##        : The model type for which supported languages should be returned.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_594022 = query.getOrDefault("upload_protocol")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "upload_protocol", valid_594022
  var valid_594023 = query.getOrDefault("fields")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "fields", valid_594023
  var valid_594024 = query.getOrDefault("quotaUser")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "quotaUser", valid_594024
  var valid_594025 = query.getOrDefault("alt")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = newJString("json"))
  if valid_594025 != nil:
    section.add "alt", valid_594025
  var valid_594026 = query.getOrDefault("pp")
  valid_594026 = validateParameter(valid_594026, JBool, required = false,
                                 default = newJBool(true))
  if valid_594026 != nil:
    section.add "pp", valid_594026
  var valid_594027 = query.getOrDefault("target")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "target", valid_594027
  var valid_594028 = query.getOrDefault("model")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "model", valid_594028
  var valid_594029 = query.getOrDefault("oauth_token")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "oauth_token", valid_594029
  var valid_594030 = query.getOrDefault("callback")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "callback", valid_594030
  var valid_594031 = query.getOrDefault("access_token")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "access_token", valid_594031
  var valid_594032 = query.getOrDefault("uploadType")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "uploadType", valid_594032
  var valid_594033 = query.getOrDefault("key")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "key", valid_594033
  var valid_594034 = query.getOrDefault("$.xgafv")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = newJString("1"))
  if valid_594034 != nil:
    section.add "$.xgafv", valid_594034
  var valid_594035 = query.getOrDefault("prettyPrint")
  valid_594035 = validateParameter(valid_594035, JBool, required = false,
                                 default = newJBool(true))
  if valid_594035 != nil:
    section.add "prettyPrint", valid_594035
  var valid_594036 = query.getOrDefault("bearer_token")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "bearer_token", valid_594036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594037: Call_LanguageLanguagesList_594019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of supported languages for translation.
  ## 
  let valid = call_594037.validator(path, query, header, formData, body)
  let scheme = call_594037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594037.url(scheme.get, call_594037.host, call_594037.base,
                         call_594037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594037, url, valid)

proc call*(call_594038: Call_LanguageLanguagesList_594019;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; target: string = ""; model: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## languageLanguagesList
  ## Returns a list of supported languages for translation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   target: string
  ##         : The language to use to return localized, human readable names of supported
  ## languages.
  ##   model: string
  ##        : The model type for which supported languages should be returned.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_594039 = newJObject()
  add(query_594039, "upload_protocol", newJString(uploadProtocol))
  add(query_594039, "fields", newJString(fields))
  add(query_594039, "quotaUser", newJString(quotaUser))
  add(query_594039, "alt", newJString(alt))
  add(query_594039, "pp", newJBool(pp))
  add(query_594039, "target", newJString(target))
  add(query_594039, "model", newJString(model))
  add(query_594039, "oauth_token", newJString(oauthToken))
  add(query_594039, "callback", newJString(callback))
  add(query_594039, "access_token", newJString(accessToken))
  add(query_594039, "uploadType", newJString(uploadType))
  add(query_594039, "key", newJString(key))
  add(query_594039, "$.xgafv", newJString(Xgafv))
  add(query_594039, "prettyPrint", newJBool(prettyPrint))
  add(query_594039, "bearer_token", newJString(bearerToken))
  result = call_594038.call(nil, query_594039, nil, nil, nil)

var languageLanguagesList* = Call_LanguageLanguagesList_594019(
    name: "languageLanguagesList", meth: HttpMethod.HttpGet,
    host: "translation.googleapis.com", route: "/v2/languages",
    validator: validate_LanguageLanguagesList_594020, base: "/language/translate",
    url: url_LanguageLanguagesList_594021, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
