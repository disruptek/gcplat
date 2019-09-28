
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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LanguageTranslationsTranslate_579957 = ref object of OpenApiRestCall_579408
proc url_LanguageTranslationsTranslate_579959(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_LanguageTranslationsTranslate_579958(path: JsonNode; query: JsonNode;
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
  var valid_579960 = query.getOrDefault("upload_protocol")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "upload_protocol", valid_579960
  var valid_579961 = query.getOrDefault("fields")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "fields", valid_579961
  var valid_579962 = query.getOrDefault("quotaUser")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "quotaUser", valid_579962
  var valid_579963 = query.getOrDefault("alt")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = newJString("json"))
  if valid_579963 != nil:
    section.add "alt", valid_579963
  var valid_579964 = query.getOrDefault("pp")
  valid_579964 = validateParameter(valid_579964, JBool, required = false,
                                 default = newJBool(true))
  if valid_579964 != nil:
    section.add "pp", valid_579964
  var valid_579965 = query.getOrDefault("oauth_token")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "oauth_token", valid_579965
  var valid_579966 = query.getOrDefault("callback")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "callback", valid_579966
  var valid_579967 = query.getOrDefault("access_token")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "access_token", valid_579967
  var valid_579968 = query.getOrDefault("uploadType")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "uploadType", valid_579968
  var valid_579969 = query.getOrDefault("key")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "key", valid_579969
  var valid_579970 = query.getOrDefault("$.xgafv")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = newJString("1"))
  if valid_579970 != nil:
    section.add "$.xgafv", valid_579970
  var valid_579971 = query.getOrDefault("prettyPrint")
  valid_579971 = validateParameter(valid_579971, JBool, required = false,
                                 default = newJBool(true))
  if valid_579971 != nil:
    section.add "prettyPrint", valid_579971
  var valid_579972 = query.getOrDefault("bearer_token")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "bearer_token", valid_579972
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

proc call*(call_579974: Call_LanguageTranslationsTranslate_579957; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Translates input text, returning translated text.
  ## 
  let valid = call_579974.validator(path, query, header, formData, body)
  let scheme = call_579974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579974.url(scheme.get, call_579974.host, call_579974.base,
                         call_579974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579974, url, valid)

proc call*(call_579975: Call_LanguageTranslationsTranslate_579957;
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
  var query_579976 = newJObject()
  var body_579977 = newJObject()
  add(query_579976, "upload_protocol", newJString(uploadProtocol))
  add(query_579976, "fields", newJString(fields))
  add(query_579976, "quotaUser", newJString(quotaUser))
  add(query_579976, "alt", newJString(alt))
  add(query_579976, "pp", newJBool(pp))
  add(query_579976, "oauth_token", newJString(oauthToken))
  add(query_579976, "callback", newJString(callback))
  add(query_579976, "access_token", newJString(accessToken))
  add(query_579976, "uploadType", newJString(uploadType))
  add(query_579976, "key", newJString(key))
  add(query_579976, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579977 = body
  add(query_579976, "prettyPrint", newJBool(prettyPrint))
  add(query_579976, "bearer_token", newJString(bearerToken))
  result = call_579975.call(nil, query_579976, nil, nil, body_579977)

var languageTranslationsTranslate* = Call_LanguageTranslationsTranslate_579957(
    name: "languageTranslationsTranslate", meth: HttpMethod.HttpPost,
    host: "translation.googleapis.com", route: "/v2",
    validator: validate_LanguageTranslationsTranslate_579958,
    base: "/language/translate", url: url_LanguageTranslationsTranslate_579959,
    schemes: {Scheme.Https})
type
  Call_LanguageTranslationsList_579677 = ref object of OpenApiRestCall_579408
proc url_LanguageTranslationsList_579679(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_LanguageTranslationsList_579678(path: JsonNode; query: JsonNode;
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
  var valid_579791 = query.getOrDefault("upload_protocol")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "upload_protocol", valid_579791
  var valid_579792 = query.getOrDefault("fields")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "fields", valid_579792
  var valid_579793 = query.getOrDefault("quotaUser")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "quotaUser", valid_579793
  var valid_579807 = query.getOrDefault("alt")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = newJString("json"))
  if valid_579807 != nil:
    section.add "alt", valid_579807
  var valid_579808 = query.getOrDefault("pp")
  valid_579808 = validateParameter(valid_579808, JBool, required = false,
                                 default = newJBool(true))
  if valid_579808 != nil:
    section.add "pp", valid_579808
  var valid_579809 = query.getOrDefault("cid")
  valid_579809 = validateParameter(valid_579809, JArray, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "cid", valid_579809
  assert query != nil, "query argument is necessary due to required `target` field"
  var valid_579810 = query.getOrDefault("target")
  valid_579810 = validateParameter(valid_579810, JString, required = true,
                                 default = nil)
  if valid_579810 != nil:
    section.add "target", valid_579810
  var valid_579811 = query.getOrDefault("model")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "model", valid_579811
  var valid_579812 = query.getOrDefault("oauth_token")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "oauth_token", valid_579812
  var valid_579813 = query.getOrDefault("callback")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = nil)
  if valid_579813 != nil:
    section.add "callback", valid_579813
  var valid_579814 = query.getOrDefault("access_token")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = nil)
  if valid_579814 != nil:
    section.add "access_token", valid_579814
  var valid_579815 = query.getOrDefault("uploadType")
  valid_579815 = validateParameter(valid_579815, JString, required = false,
                                 default = nil)
  if valid_579815 != nil:
    section.add "uploadType", valid_579815
  var valid_579816 = query.getOrDefault("source")
  valid_579816 = validateParameter(valid_579816, JString, required = false,
                                 default = nil)
  if valid_579816 != nil:
    section.add "source", valid_579816
  var valid_579817 = query.getOrDefault("q")
  valid_579817 = validateParameter(valid_579817, JArray, required = true, default = nil)
  if valid_579817 != nil:
    section.add "q", valid_579817
  var valid_579818 = query.getOrDefault("key")
  valid_579818 = validateParameter(valid_579818, JString, required = false,
                                 default = nil)
  if valid_579818 != nil:
    section.add "key", valid_579818
  var valid_579819 = query.getOrDefault("$.xgafv")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = newJString("1"))
  if valid_579819 != nil:
    section.add "$.xgafv", valid_579819
  var valid_579820 = query.getOrDefault("prettyPrint")
  valid_579820 = validateParameter(valid_579820, JBool, required = false,
                                 default = newJBool(true))
  if valid_579820 != nil:
    section.add "prettyPrint", valid_579820
  var valid_579821 = query.getOrDefault("format")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = newJString("html"))
  if valid_579821 != nil:
    section.add "format", valid_579821
  var valid_579822 = query.getOrDefault("bearer_token")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "bearer_token", valid_579822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579845: Call_LanguageTranslationsList_579677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Translates input text, returning translated text.
  ## 
  let valid = call_579845.validator(path, query, header, formData, body)
  let scheme = call_579845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579845.url(scheme.get, call_579845.host, call_579845.base,
                         call_579845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579845, url, valid)

proc call*(call_579916: Call_LanguageTranslationsList_579677; target: string;
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
  var query_579917 = newJObject()
  add(query_579917, "upload_protocol", newJString(uploadProtocol))
  add(query_579917, "fields", newJString(fields))
  add(query_579917, "quotaUser", newJString(quotaUser))
  add(query_579917, "alt", newJString(alt))
  add(query_579917, "pp", newJBool(pp))
  if cid != nil:
    query_579917.add "cid", cid
  add(query_579917, "target", newJString(target))
  add(query_579917, "model", newJString(model))
  add(query_579917, "oauth_token", newJString(oauthToken))
  add(query_579917, "callback", newJString(callback))
  add(query_579917, "access_token", newJString(accessToken))
  add(query_579917, "uploadType", newJString(uploadType))
  add(query_579917, "source", newJString(source))
  if q != nil:
    query_579917.add "q", q
  add(query_579917, "key", newJString(key))
  add(query_579917, "$.xgafv", newJString(Xgafv))
  add(query_579917, "prettyPrint", newJBool(prettyPrint))
  add(query_579917, "format", newJString(format))
  add(query_579917, "bearer_token", newJString(bearerToken))
  result = call_579916.call(nil, query_579917, nil, nil, nil)

var languageTranslationsList* = Call_LanguageTranslationsList_579677(
    name: "languageTranslationsList", meth: HttpMethod.HttpGet,
    host: "translation.googleapis.com", route: "/v2",
    validator: validate_LanguageTranslationsList_579678,
    base: "/language/translate", url: url_LanguageTranslationsList_579679,
    schemes: {Scheme.Https})
type
  Call_LanguageDetectionsDetect_579998 = ref object of OpenApiRestCall_579408
proc url_LanguageDetectionsDetect_580000(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_LanguageDetectionsDetect_579999(path: JsonNode; query: JsonNode;
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
  var valid_580001 = query.getOrDefault("upload_protocol")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "upload_protocol", valid_580001
  var valid_580002 = query.getOrDefault("fields")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "fields", valid_580002
  var valid_580003 = query.getOrDefault("quotaUser")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "quotaUser", valid_580003
  var valid_580004 = query.getOrDefault("alt")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = newJString("json"))
  if valid_580004 != nil:
    section.add "alt", valid_580004
  var valid_580005 = query.getOrDefault("pp")
  valid_580005 = validateParameter(valid_580005, JBool, required = false,
                                 default = newJBool(true))
  if valid_580005 != nil:
    section.add "pp", valid_580005
  var valid_580006 = query.getOrDefault("oauth_token")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "oauth_token", valid_580006
  var valid_580007 = query.getOrDefault("callback")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "callback", valid_580007
  var valid_580008 = query.getOrDefault("access_token")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "access_token", valid_580008
  var valid_580009 = query.getOrDefault("uploadType")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "uploadType", valid_580009
  var valid_580010 = query.getOrDefault("key")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "key", valid_580010
  var valid_580011 = query.getOrDefault("$.xgafv")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = newJString("1"))
  if valid_580011 != nil:
    section.add "$.xgafv", valid_580011
  var valid_580012 = query.getOrDefault("prettyPrint")
  valid_580012 = validateParameter(valid_580012, JBool, required = false,
                                 default = newJBool(true))
  if valid_580012 != nil:
    section.add "prettyPrint", valid_580012
  var valid_580013 = query.getOrDefault("bearer_token")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "bearer_token", valid_580013
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

proc call*(call_580015: Call_LanguageDetectionsDetect_579998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detects the language of text within a request.
  ## 
  let valid = call_580015.validator(path, query, header, formData, body)
  let scheme = call_580015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580015.url(scheme.get, call_580015.host, call_580015.base,
                         call_580015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580015, url, valid)

proc call*(call_580016: Call_LanguageDetectionsDetect_579998;
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
  var query_580017 = newJObject()
  var body_580018 = newJObject()
  add(query_580017, "upload_protocol", newJString(uploadProtocol))
  add(query_580017, "fields", newJString(fields))
  add(query_580017, "quotaUser", newJString(quotaUser))
  add(query_580017, "alt", newJString(alt))
  add(query_580017, "pp", newJBool(pp))
  add(query_580017, "oauth_token", newJString(oauthToken))
  add(query_580017, "callback", newJString(callback))
  add(query_580017, "access_token", newJString(accessToken))
  add(query_580017, "uploadType", newJString(uploadType))
  add(query_580017, "key", newJString(key))
  add(query_580017, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580018 = body
  add(query_580017, "prettyPrint", newJBool(prettyPrint))
  add(query_580017, "bearer_token", newJString(bearerToken))
  result = call_580016.call(nil, query_580017, nil, nil, body_580018)

var languageDetectionsDetect* = Call_LanguageDetectionsDetect_579998(
    name: "languageDetectionsDetect", meth: HttpMethod.HttpPost,
    host: "translation.googleapis.com", route: "/v2/detect",
    validator: validate_LanguageDetectionsDetect_579999,
    base: "/language/translate", url: url_LanguageDetectionsDetect_580000,
    schemes: {Scheme.Https})
type
  Call_LanguageDetectionsList_579978 = ref object of OpenApiRestCall_579408
proc url_LanguageDetectionsList_579980(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_LanguageDetectionsList_579979(path: JsonNode; query: JsonNode;
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
  var valid_579981 = query.getOrDefault("upload_protocol")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "upload_protocol", valid_579981
  var valid_579982 = query.getOrDefault("fields")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "fields", valid_579982
  var valid_579983 = query.getOrDefault("quotaUser")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "quotaUser", valid_579983
  var valid_579984 = query.getOrDefault("alt")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = newJString("json"))
  if valid_579984 != nil:
    section.add "alt", valid_579984
  var valid_579985 = query.getOrDefault("pp")
  valid_579985 = validateParameter(valid_579985, JBool, required = false,
                                 default = newJBool(true))
  if valid_579985 != nil:
    section.add "pp", valid_579985
  var valid_579986 = query.getOrDefault("oauth_token")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "oauth_token", valid_579986
  var valid_579987 = query.getOrDefault("callback")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "callback", valid_579987
  var valid_579988 = query.getOrDefault("access_token")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "access_token", valid_579988
  var valid_579989 = query.getOrDefault("uploadType")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "uploadType", valid_579989
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_579990 = query.getOrDefault("q")
  valid_579990 = validateParameter(valid_579990, JArray, required = true, default = nil)
  if valid_579990 != nil:
    section.add "q", valid_579990
  var valid_579991 = query.getOrDefault("key")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "key", valid_579991
  var valid_579992 = query.getOrDefault("$.xgafv")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = newJString("1"))
  if valid_579992 != nil:
    section.add "$.xgafv", valid_579992
  var valid_579993 = query.getOrDefault("prettyPrint")
  valid_579993 = validateParameter(valid_579993, JBool, required = false,
                                 default = newJBool(true))
  if valid_579993 != nil:
    section.add "prettyPrint", valid_579993
  var valid_579994 = query.getOrDefault("bearer_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "bearer_token", valid_579994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579995: Call_LanguageDetectionsList_579978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detects the language of text within a request.
  ## 
  let valid = call_579995.validator(path, query, header, formData, body)
  let scheme = call_579995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579995.url(scheme.get, call_579995.host, call_579995.base,
                         call_579995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579995, url, valid)

proc call*(call_579996: Call_LanguageDetectionsList_579978; q: JsonNode;
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
  var query_579997 = newJObject()
  add(query_579997, "upload_protocol", newJString(uploadProtocol))
  add(query_579997, "fields", newJString(fields))
  add(query_579997, "quotaUser", newJString(quotaUser))
  add(query_579997, "alt", newJString(alt))
  add(query_579997, "pp", newJBool(pp))
  add(query_579997, "oauth_token", newJString(oauthToken))
  add(query_579997, "callback", newJString(callback))
  add(query_579997, "access_token", newJString(accessToken))
  add(query_579997, "uploadType", newJString(uploadType))
  if q != nil:
    query_579997.add "q", q
  add(query_579997, "key", newJString(key))
  add(query_579997, "$.xgafv", newJString(Xgafv))
  add(query_579997, "prettyPrint", newJBool(prettyPrint))
  add(query_579997, "bearer_token", newJString(bearerToken))
  result = call_579996.call(nil, query_579997, nil, nil, nil)

var languageDetectionsList* = Call_LanguageDetectionsList_579978(
    name: "languageDetectionsList", meth: HttpMethod.HttpGet,
    host: "translation.googleapis.com", route: "/v2/detect",
    validator: validate_LanguageDetectionsList_579979,
    base: "/language/translate", url: url_LanguageDetectionsList_579980,
    schemes: {Scheme.Https})
type
  Call_LanguageLanguagesList_580019 = ref object of OpenApiRestCall_579408
proc url_LanguageLanguagesList_580021(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_LanguageLanguagesList_580020(path: JsonNode; query: JsonNode;
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
  var valid_580022 = query.getOrDefault("upload_protocol")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "upload_protocol", valid_580022
  var valid_580023 = query.getOrDefault("fields")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "fields", valid_580023
  var valid_580024 = query.getOrDefault("quotaUser")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "quotaUser", valid_580024
  var valid_580025 = query.getOrDefault("alt")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = newJString("json"))
  if valid_580025 != nil:
    section.add "alt", valid_580025
  var valid_580026 = query.getOrDefault("pp")
  valid_580026 = validateParameter(valid_580026, JBool, required = false,
                                 default = newJBool(true))
  if valid_580026 != nil:
    section.add "pp", valid_580026
  var valid_580027 = query.getOrDefault("target")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "target", valid_580027
  var valid_580028 = query.getOrDefault("model")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "model", valid_580028
  var valid_580029 = query.getOrDefault("oauth_token")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "oauth_token", valid_580029
  var valid_580030 = query.getOrDefault("callback")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "callback", valid_580030
  var valid_580031 = query.getOrDefault("access_token")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "access_token", valid_580031
  var valid_580032 = query.getOrDefault("uploadType")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "uploadType", valid_580032
  var valid_580033 = query.getOrDefault("key")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "key", valid_580033
  var valid_580034 = query.getOrDefault("$.xgafv")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("1"))
  if valid_580034 != nil:
    section.add "$.xgafv", valid_580034
  var valid_580035 = query.getOrDefault("prettyPrint")
  valid_580035 = validateParameter(valid_580035, JBool, required = false,
                                 default = newJBool(true))
  if valid_580035 != nil:
    section.add "prettyPrint", valid_580035
  var valid_580036 = query.getOrDefault("bearer_token")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "bearer_token", valid_580036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580037: Call_LanguageLanguagesList_580019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of supported languages for translation.
  ## 
  let valid = call_580037.validator(path, query, header, formData, body)
  let scheme = call_580037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580037.url(scheme.get, call_580037.host, call_580037.base,
                         call_580037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580037, url, valid)

proc call*(call_580038: Call_LanguageLanguagesList_580019;
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
  var query_580039 = newJObject()
  add(query_580039, "upload_protocol", newJString(uploadProtocol))
  add(query_580039, "fields", newJString(fields))
  add(query_580039, "quotaUser", newJString(quotaUser))
  add(query_580039, "alt", newJString(alt))
  add(query_580039, "pp", newJBool(pp))
  add(query_580039, "target", newJString(target))
  add(query_580039, "model", newJString(model))
  add(query_580039, "oauth_token", newJString(oauthToken))
  add(query_580039, "callback", newJString(callback))
  add(query_580039, "access_token", newJString(accessToken))
  add(query_580039, "uploadType", newJString(uploadType))
  add(query_580039, "key", newJString(key))
  add(query_580039, "$.xgafv", newJString(Xgafv))
  add(query_580039, "prettyPrint", newJBool(prettyPrint))
  add(query_580039, "bearer_token", newJString(bearerToken))
  result = call_580038.call(nil, query_580039, nil, nil, nil)

var languageLanguagesList* = Call_LanguageLanguagesList_580019(
    name: "languageLanguagesList", meth: HttpMethod.HttpGet,
    host: "translation.googleapis.com", route: "/v2/languages",
    validator: validate_LanguageLanguagesList_580020, base: "/language/translate",
    url: url_LanguageLanguagesList_580021, schemes: {Scheme.Https})
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
