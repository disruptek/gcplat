
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Cloud Natural Language
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Provides natural language understanding technologies, such as sentiment analysis, entity recognition, entity sentiment analysis, and other text annotations, to developers.
## 
## https://cloud.google.com/natural-language/
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
  gcpServiceName = "language"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LanguageDocumentsAnalyzeEntities_593677 = ref object of OpenApiRestCall_593408
proc url_LanguageDocumentsAnalyzeEntities_593679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LanguageDocumentsAnalyzeEntities_593678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Finds named entities (currently proper names and common nouns) in the text
  ## along with entity types, salience, mentions for each entity, and
  ## other properties.
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
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
  var valid_593808 = query.getOrDefault("oauth_token")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "oauth_token", valid_593808
  var valid_593809 = query.getOrDefault("callback")
  valid_593809 = validateParameter(valid_593809, JString, required = false,
                                 default = nil)
  if valid_593809 != nil:
    section.add "callback", valid_593809
  var valid_593810 = query.getOrDefault("access_token")
  valid_593810 = validateParameter(valid_593810, JString, required = false,
                                 default = nil)
  if valid_593810 != nil:
    section.add "access_token", valid_593810
  var valid_593811 = query.getOrDefault("uploadType")
  valid_593811 = validateParameter(valid_593811, JString, required = false,
                                 default = nil)
  if valid_593811 != nil:
    section.add "uploadType", valid_593811
  var valid_593812 = query.getOrDefault("key")
  valid_593812 = validateParameter(valid_593812, JString, required = false,
                                 default = nil)
  if valid_593812 != nil:
    section.add "key", valid_593812
  var valid_593813 = query.getOrDefault("$.xgafv")
  valid_593813 = validateParameter(valid_593813, JString, required = false,
                                 default = newJString("1"))
  if valid_593813 != nil:
    section.add "$.xgafv", valid_593813
  var valid_593814 = query.getOrDefault("prettyPrint")
  valid_593814 = validateParameter(valid_593814, JBool, required = false,
                                 default = newJBool(true))
  if valid_593814 != nil:
    section.add "prettyPrint", valid_593814
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

proc call*(call_593838: Call_LanguageDocumentsAnalyzeEntities_593677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Finds named entities (currently proper names and common nouns) in the text
  ## along with entity types, salience, mentions for each entity, and
  ## other properties.
  ## 
  let valid = call_593838.validator(path, query, header, formData, body)
  let scheme = call_593838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593838.url(scheme.get, call_593838.host, call_593838.base,
                         call_593838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593838, url, valid)

proc call*(call_593909: Call_LanguageDocumentsAnalyzeEntities_593677;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## languageDocumentsAnalyzeEntities
  ## Finds named entities (currently proper names and common nouns) in the text
  ## along with entity types, salience, mentions for each entity, and
  ## other properties.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  var query_593910 = newJObject()
  var body_593912 = newJObject()
  add(query_593910, "upload_protocol", newJString(uploadProtocol))
  add(query_593910, "fields", newJString(fields))
  add(query_593910, "quotaUser", newJString(quotaUser))
  add(query_593910, "alt", newJString(alt))
  add(query_593910, "oauth_token", newJString(oauthToken))
  add(query_593910, "callback", newJString(callback))
  add(query_593910, "access_token", newJString(accessToken))
  add(query_593910, "uploadType", newJString(uploadType))
  add(query_593910, "key", newJString(key))
  add(query_593910, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593912 = body
  add(query_593910, "prettyPrint", newJBool(prettyPrint))
  result = call_593909.call(nil, query_593910, nil, nil, body_593912)

var languageDocumentsAnalyzeEntities* = Call_LanguageDocumentsAnalyzeEntities_593677(
    name: "languageDocumentsAnalyzeEntities", meth: HttpMethod.HttpPost,
    host: "language.googleapis.com", route: "/v1/documents:analyzeEntities",
    validator: validate_LanguageDocumentsAnalyzeEntities_593678, base: "/",
    url: url_LanguageDocumentsAnalyzeEntities_593679, schemes: {Scheme.Https})
type
  Call_LanguageDocumentsAnalyzeEntitySentiment_593951 = ref object of OpenApiRestCall_593408
proc url_LanguageDocumentsAnalyzeEntitySentiment_593953(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LanguageDocumentsAnalyzeEntitySentiment_593952(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Finds entities, similar to AnalyzeEntities in the text and analyzes
  ## sentiment associated with each entity and its mentions.
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
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
  section = newJObject()
  var valid_593954 = query.getOrDefault("upload_protocol")
  valid_593954 = validateParameter(valid_593954, JString, required = false,
                                 default = nil)
  if valid_593954 != nil:
    section.add "upload_protocol", valid_593954
  var valid_593955 = query.getOrDefault("fields")
  valid_593955 = validateParameter(valid_593955, JString, required = false,
                                 default = nil)
  if valid_593955 != nil:
    section.add "fields", valid_593955
  var valid_593956 = query.getOrDefault("quotaUser")
  valid_593956 = validateParameter(valid_593956, JString, required = false,
                                 default = nil)
  if valid_593956 != nil:
    section.add "quotaUser", valid_593956
  var valid_593957 = query.getOrDefault("alt")
  valid_593957 = validateParameter(valid_593957, JString, required = false,
                                 default = newJString("json"))
  if valid_593957 != nil:
    section.add "alt", valid_593957
  var valid_593958 = query.getOrDefault("oauth_token")
  valid_593958 = validateParameter(valid_593958, JString, required = false,
                                 default = nil)
  if valid_593958 != nil:
    section.add "oauth_token", valid_593958
  var valid_593959 = query.getOrDefault("callback")
  valid_593959 = validateParameter(valid_593959, JString, required = false,
                                 default = nil)
  if valid_593959 != nil:
    section.add "callback", valid_593959
  var valid_593960 = query.getOrDefault("access_token")
  valid_593960 = validateParameter(valid_593960, JString, required = false,
                                 default = nil)
  if valid_593960 != nil:
    section.add "access_token", valid_593960
  var valid_593961 = query.getOrDefault("uploadType")
  valid_593961 = validateParameter(valid_593961, JString, required = false,
                                 default = nil)
  if valid_593961 != nil:
    section.add "uploadType", valid_593961
  var valid_593962 = query.getOrDefault("key")
  valid_593962 = validateParameter(valid_593962, JString, required = false,
                                 default = nil)
  if valid_593962 != nil:
    section.add "key", valid_593962
  var valid_593963 = query.getOrDefault("$.xgafv")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = newJString("1"))
  if valid_593963 != nil:
    section.add "$.xgafv", valid_593963
  var valid_593964 = query.getOrDefault("prettyPrint")
  valid_593964 = validateParameter(valid_593964, JBool, required = false,
                                 default = newJBool(true))
  if valid_593964 != nil:
    section.add "prettyPrint", valid_593964
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

proc call*(call_593966: Call_LanguageDocumentsAnalyzeEntitySentiment_593951;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Finds entities, similar to AnalyzeEntities in the text and analyzes
  ## sentiment associated with each entity and its mentions.
  ## 
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_LanguageDocumentsAnalyzeEntitySentiment_593951;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## languageDocumentsAnalyzeEntitySentiment
  ## Finds entities, similar to AnalyzeEntities in the text and analyzes
  ## sentiment associated with each entity and its mentions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  var query_593968 = newJObject()
  var body_593969 = newJObject()
  add(query_593968, "upload_protocol", newJString(uploadProtocol))
  add(query_593968, "fields", newJString(fields))
  add(query_593968, "quotaUser", newJString(quotaUser))
  add(query_593968, "alt", newJString(alt))
  add(query_593968, "oauth_token", newJString(oauthToken))
  add(query_593968, "callback", newJString(callback))
  add(query_593968, "access_token", newJString(accessToken))
  add(query_593968, "uploadType", newJString(uploadType))
  add(query_593968, "key", newJString(key))
  add(query_593968, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593969 = body
  add(query_593968, "prettyPrint", newJBool(prettyPrint))
  result = call_593967.call(nil, query_593968, nil, nil, body_593969)

var languageDocumentsAnalyzeEntitySentiment* = Call_LanguageDocumentsAnalyzeEntitySentiment_593951(
    name: "languageDocumentsAnalyzeEntitySentiment", meth: HttpMethod.HttpPost,
    host: "language.googleapis.com",
    route: "/v1/documents:analyzeEntitySentiment",
    validator: validate_LanguageDocumentsAnalyzeEntitySentiment_593952, base: "/",
    url: url_LanguageDocumentsAnalyzeEntitySentiment_593953,
    schemes: {Scheme.Https})
type
  Call_LanguageDocumentsAnalyzeSentiment_593970 = ref object of OpenApiRestCall_593408
proc url_LanguageDocumentsAnalyzeSentiment_593972(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LanguageDocumentsAnalyzeSentiment_593971(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Analyzes the sentiment of the provided text.
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
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
  section = newJObject()
  var valid_593973 = query.getOrDefault("upload_protocol")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "upload_protocol", valid_593973
  var valid_593974 = query.getOrDefault("fields")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "fields", valid_593974
  var valid_593975 = query.getOrDefault("quotaUser")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "quotaUser", valid_593975
  var valid_593976 = query.getOrDefault("alt")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = newJString("json"))
  if valid_593976 != nil:
    section.add "alt", valid_593976
  var valid_593977 = query.getOrDefault("oauth_token")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "oauth_token", valid_593977
  var valid_593978 = query.getOrDefault("callback")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "callback", valid_593978
  var valid_593979 = query.getOrDefault("access_token")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "access_token", valid_593979
  var valid_593980 = query.getOrDefault("uploadType")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "uploadType", valid_593980
  var valid_593981 = query.getOrDefault("key")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "key", valid_593981
  var valid_593982 = query.getOrDefault("$.xgafv")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = newJString("1"))
  if valid_593982 != nil:
    section.add "$.xgafv", valid_593982
  var valid_593983 = query.getOrDefault("prettyPrint")
  valid_593983 = validateParameter(valid_593983, JBool, required = false,
                                 default = newJBool(true))
  if valid_593983 != nil:
    section.add "prettyPrint", valid_593983
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

proc call*(call_593985: Call_LanguageDocumentsAnalyzeSentiment_593970;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Analyzes the sentiment of the provided text.
  ## 
  let valid = call_593985.validator(path, query, header, formData, body)
  let scheme = call_593985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593985.url(scheme.get, call_593985.host, call_593985.base,
                         call_593985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593985, url, valid)

proc call*(call_593986: Call_LanguageDocumentsAnalyzeSentiment_593970;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## languageDocumentsAnalyzeSentiment
  ## Analyzes the sentiment of the provided text.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  var query_593987 = newJObject()
  var body_593988 = newJObject()
  add(query_593987, "upload_protocol", newJString(uploadProtocol))
  add(query_593987, "fields", newJString(fields))
  add(query_593987, "quotaUser", newJString(quotaUser))
  add(query_593987, "alt", newJString(alt))
  add(query_593987, "oauth_token", newJString(oauthToken))
  add(query_593987, "callback", newJString(callback))
  add(query_593987, "access_token", newJString(accessToken))
  add(query_593987, "uploadType", newJString(uploadType))
  add(query_593987, "key", newJString(key))
  add(query_593987, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593988 = body
  add(query_593987, "prettyPrint", newJBool(prettyPrint))
  result = call_593986.call(nil, query_593987, nil, nil, body_593988)

var languageDocumentsAnalyzeSentiment* = Call_LanguageDocumentsAnalyzeSentiment_593970(
    name: "languageDocumentsAnalyzeSentiment", meth: HttpMethod.HttpPost,
    host: "language.googleapis.com", route: "/v1/documents:analyzeSentiment",
    validator: validate_LanguageDocumentsAnalyzeSentiment_593971, base: "/",
    url: url_LanguageDocumentsAnalyzeSentiment_593972, schemes: {Scheme.Https})
type
  Call_LanguageDocumentsAnalyzeSyntax_593989 = ref object of OpenApiRestCall_593408
proc url_LanguageDocumentsAnalyzeSyntax_593991(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LanguageDocumentsAnalyzeSyntax_593990(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Analyzes the syntax of the text and provides sentence boundaries and
  ## tokenization along with part of speech tags, dependency trees, and other
  ## properties.
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
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
  section = newJObject()
  var valid_593992 = query.getOrDefault("upload_protocol")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "upload_protocol", valid_593992
  var valid_593993 = query.getOrDefault("fields")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "fields", valid_593993
  var valid_593994 = query.getOrDefault("quotaUser")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "quotaUser", valid_593994
  var valid_593995 = query.getOrDefault("alt")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = newJString("json"))
  if valid_593995 != nil:
    section.add "alt", valid_593995
  var valid_593996 = query.getOrDefault("oauth_token")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "oauth_token", valid_593996
  var valid_593997 = query.getOrDefault("callback")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "callback", valid_593997
  var valid_593998 = query.getOrDefault("access_token")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "access_token", valid_593998
  var valid_593999 = query.getOrDefault("uploadType")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "uploadType", valid_593999
  var valid_594000 = query.getOrDefault("key")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "key", valid_594000
  var valid_594001 = query.getOrDefault("$.xgafv")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = newJString("1"))
  if valid_594001 != nil:
    section.add "$.xgafv", valid_594001
  var valid_594002 = query.getOrDefault("prettyPrint")
  valid_594002 = validateParameter(valid_594002, JBool, required = false,
                                 default = newJBool(true))
  if valid_594002 != nil:
    section.add "prettyPrint", valid_594002
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

proc call*(call_594004: Call_LanguageDocumentsAnalyzeSyntax_593989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Analyzes the syntax of the text and provides sentence boundaries and
  ## tokenization along with part of speech tags, dependency trees, and other
  ## properties.
  ## 
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_LanguageDocumentsAnalyzeSyntax_593989;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## languageDocumentsAnalyzeSyntax
  ## Analyzes the syntax of the text and provides sentence boundaries and
  ## tokenization along with part of speech tags, dependency trees, and other
  ## properties.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  var query_594006 = newJObject()
  var body_594007 = newJObject()
  add(query_594006, "upload_protocol", newJString(uploadProtocol))
  add(query_594006, "fields", newJString(fields))
  add(query_594006, "quotaUser", newJString(quotaUser))
  add(query_594006, "alt", newJString(alt))
  add(query_594006, "oauth_token", newJString(oauthToken))
  add(query_594006, "callback", newJString(callback))
  add(query_594006, "access_token", newJString(accessToken))
  add(query_594006, "uploadType", newJString(uploadType))
  add(query_594006, "key", newJString(key))
  add(query_594006, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594007 = body
  add(query_594006, "prettyPrint", newJBool(prettyPrint))
  result = call_594005.call(nil, query_594006, nil, nil, body_594007)

var languageDocumentsAnalyzeSyntax* = Call_LanguageDocumentsAnalyzeSyntax_593989(
    name: "languageDocumentsAnalyzeSyntax", meth: HttpMethod.HttpPost,
    host: "language.googleapis.com", route: "/v1/documents:analyzeSyntax",
    validator: validate_LanguageDocumentsAnalyzeSyntax_593990, base: "/",
    url: url_LanguageDocumentsAnalyzeSyntax_593991, schemes: {Scheme.Https})
type
  Call_LanguageDocumentsAnnotateText_594008 = ref object of OpenApiRestCall_593408
proc url_LanguageDocumentsAnnotateText_594010(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LanguageDocumentsAnnotateText_594009(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## A convenience method that provides all the features that analyzeSentiment,
  ## analyzeEntities, and analyzeSyntax provide in one call.
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
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
  section = newJObject()
  var valid_594011 = query.getOrDefault("upload_protocol")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "upload_protocol", valid_594011
  var valid_594012 = query.getOrDefault("fields")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "fields", valid_594012
  var valid_594013 = query.getOrDefault("quotaUser")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "quotaUser", valid_594013
  var valid_594014 = query.getOrDefault("alt")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = newJString("json"))
  if valid_594014 != nil:
    section.add "alt", valid_594014
  var valid_594015 = query.getOrDefault("oauth_token")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "oauth_token", valid_594015
  var valid_594016 = query.getOrDefault("callback")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "callback", valid_594016
  var valid_594017 = query.getOrDefault("access_token")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "access_token", valid_594017
  var valid_594018 = query.getOrDefault("uploadType")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "uploadType", valid_594018
  var valid_594019 = query.getOrDefault("key")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "key", valid_594019
  var valid_594020 = query.getOrDefault("$.xgafv")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = newJString("1"))
  if valid_594020 != nil:
    section.add "$.xgafv", valid_594020
  var valid_594021 = query.getOrDefault("prettyPrint")
  valid_594021 = validateParameter(valid_594021, JBool, required = false,
                                 default = newJBool(true))
  if valid_594021 != nil:
    section.add "prettyPrint", valid_594021
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

proc call*(call_594023: Call_LanguageDocumentsAnnotateText_594008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## A convenience method that provides all the features that analyzeSentiment,
  ## analyzeEntities, and analyzeSyntax provide in one call.
  ## 
  let valid = call_594023.validator(path, query, header, formData, body)
  let scheme = call_594023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594023.url(scheme.get, call_594023.host, call_594023.base,
                         call_594023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594023, url, valid)

proc call*(call_594024: Call_LanguageDocumentsAnnotateText_594008;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## languageDocumentsAnnotateText
  ## A convenience method that provides all the features that analyzeSentiment,
  ## analyzeEntities, and analyzeSyntax provide in one call.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  var query_594025 = newJObject()
  var body_594026 = newJObject()
  add(query_594025, "upload_protocol", newJString(uploadProtocol))
  add(query_594025, "fields", newJString(fields))
  add(query_594025, "quotaUser", newJString(quotaUser))
  add(query_594025, "alt", newJString(alt))
  add(query_594025, "oauth_token", newJString(oauthToken))
  add(query_594025, "callback", newJString(callback))
  add(query_594025, "access_token", newJString(accessToken))
  add(query_594025, "uploadType", newJString(uploadType))
  add(query_594025, "key", newJString(key))
  add(query_594025, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594026 = body
  add(query_594025, "prettyPrint", newJBool(prettyPrint))
  result = call_594024.call(nil, query_594025, nil, nil, body_594026)

var languageDocumentsAnnotateText* = Call_LanguageDocumentsAnnotateText_594008(
    name: "languageDocumentsAnnotateText", meth: HttpMethod.HttpPost,
    host: "language.googleapis.com", route: "/v1/documents:annotateText",
    validator: validate_LanguageDocumentsAnnotateText_594009, base: "/",
    url: url_LanguageDocumentsAnnotateText_594010, schemes: {Scheme.Https})
type
  Call_LanguageDocumentsClassifyText_594027 = ref object of OpenApiRestCall_593408
proc url_LanguageDocumentsClassifyText_594029(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LanguageDocumentsClassifyText_594028(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Classifies a document into categories.
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
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
  section = newJObject()
  var valid_594030 = query.getOrDefault("upload_protocol")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "upload_protocol", valid_594030
  var valid_594031 = query.getOrDefault("fields")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "fields", valid_594031
  var valid_594032 = query.getOrDefault("quotaUser")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "quotaUser", valid_594032
  var valid_594033 = query.getOrDefault("alt")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = newJString("json"))
  if valid_594033 != nil:
    section.add "alt", valid_594033
  var valid_594034 = query.getOrDefault("oauth_token")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "oauth_token", valid_594034
  var valid_594035 = query.getOrDefault("callback")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "callback", valid_594035
  var valid_594036 = query.getOrDefault("access_token")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "access_token", valid_594036
  var valid_594037 = query.getOrDefault("uploadType")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "uploadType", valid_594037
  var valid_594038 = query.getOrDefault("key")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "key", valid_594038
  var valid_594039 = query.getOrDefault("$.xgafv")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = newJString("1"))
  if valid_594039 != nil:
    section.add "$.xgafv", valid_594039
  var valid_594040 = query.getOrDefault("prettyPrint")
  valid_594040 = validateParameter(valid_594040, JBool, required = false,
                                 default = newJBool(true))
  if valid_594040 != nil:
    section.add "prettyPrint", valid_594040
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

proc call*(call_594042: Call_LanguageDocumentsClassifyText_594027; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Classifies a document into categories.
  ## 
  let valid = call_594042.validator(path, query, header, formData, body)
  let scheme = call_594042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594042.url(scheme.get, call_594042.host, call_594042.base,
                         call_594042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594042, url, valid)

proc call*(call_594043: Call_LanguageDocumentsClassifyText_594027;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## languageDocumentsClassifyText
  ## Classifies a document into categories.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  var query_594044 = newJObject()
  var body_594045 = newJObject()
  add(query_594044, "upload_protocol", newJString(uploadProtocol))
  add(query_594044, "fields", newJString(fields))
  add(query_594044, "quotaUser", newJString(quotaUser))
  add(query_594044, "alt", newJString(alt))
  add(query_594044, "oauth_token", newJString(oauthToken))
  add(query_594044, "callback", newJString(callback))
  add(query_594044, "access_token", newJString(accessToken))
  add(query_594044, "uploadType", newJString(uploadType))
  add(query_594044, "key", newJString(key))
  add(query_594044, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594045 = body
  add(query_594044, "prettyPrint", newJBool(prettyPrint))
  result = call_594043.call(nil, query_594044, nil, nil, body_594045)

var languageDocumentsClassifyText* = Call_LanguageDocumentsClassifyText_594027(
    name: "languageDocumentsClassifyText", meth: HttpMethod.HttpPost,
    host: "language.googleapis.com", route: "/v1/documents:classifyText",
    validator: validate_LanguageDocumentsClassifyText_594028, base: "/",
    url: url_LanguageDocumentsClassifyText_594029, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
