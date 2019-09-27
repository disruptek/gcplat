
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: URL Shortener
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Lets you create, inspect, and manage goo.gl short URLs
## 
## https://developers.google.com/url-shortener/v1/getting_started
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
  gcpServiceName = "urlshortener"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_UrlshortenerUrlInsert_593946 = ref object of OpenApiRestCall_593408
proc url_UrlshortenerUrlInsert_593948(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_UrlshortenerUrlInsert_593947(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new short URL.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593949 = query.getOrDefault("fields")
  valid_593949 = validateParameter(valid_593949, JString, required = false,
                                 default = nil)
  if valid_593949 != nil:
    section.add "fields", valid_593949
  var valid_593950 = query.getOrDefault("quotaUser")
  valid_593950 = validateParameter(valid_593950, JString, required = false,
                                 default = nil)
  if valid_593950 != nil:
    section.add "quotaUser", valid_593950
  var valid_593951 = query.getOrDefault("alt")
  valid_593951 = validateParameter(valid_593951, JString, required = false,
                                 default = newJString("json"))
  if valid_593951 != nil:
    section.add "alt", valid_593951
  var valid_593952 = query.getOrDefault("oauth_token")
  valid_593952 = validateParameter(valid_593952, JString, required = false,
                                 default = nil)
  if valid_593952 != nil:
    section.add "oauth_token", valid_593952
  var valid_593953 = query.getOrDefault("userIp")
  valid_593953 = validateParameter(valid_593953, JString, required = false,
                                 default = nil)
  if valid_593953 != nil:
    section.add "userIp", valid_593953
  var valid_593954 = query.getOrDefault("key")
  valid_593954 = validateParameter(valid_593954, JString, required = false,
                                 default = nil)
  if valid_593954 != nil:
    section.add "key", valid_593954
  var valid_593955 = query.getOrDefault("prettyPrint")
  valid_593955 = validateParameter(valid_593955, JBool, required = false,
                                 default = newJBool(true))
  if valid_593955 != nil:
    section.add "prettyPrint", valid_593955
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

proc call*(call_593957: Call_UrlshortenerUrlInsert_593946; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new short URL.
  ## 
  let valid = call_593957.validator(path, query, header, formData, body)
  let scheme = call_593957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593957.url(scheme.get, call_593957.host, call_593957.base,
                         call_593957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593957, url, valid)

proc call*(call_593958: Call_UrlshortenerUrlInsert_593946; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## urlshortenerUrlInsert
  ## Creates a new short URL.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593959 = newJObject()
  var body_593960 = newJObject()
  add(query_593959, "fields", newJString(fields))
  add(query_593959, "quotaUser", newJString(quotaUser))
  add(query_593959, "alt", newJString(alt))
  add(query_593959, "oauth_token", newJString(oauthToken))
  add(query_593959, "userIp", newJString(userIp))
  add(query_593959, "key", newJString(key))
  if body != nil:
    body_593960 = body
  add(query_593959, "prettyPrint", newJBool(prettyPrint))
  result = call_593958.call(nil, query_593959, nil, nil, body_593960)

var urlshortenerUrlInsert* = Call_UrlshortenerUrlInsert_593946(
    name: "urlshortenerUrlInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/url",
    validator: validate_UrlshortenerUrlInsert_593947, base: "/urlshortener/v1",
    url: url_UrlshortenerUrlInsert_593948, schemes: {Scheme.Https})
type
  Call_UrlshortenerUrlGet_593676 = ref object of OpenApiRestCall_593408
proc url_UrlshortenerUrlGet_593678(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_UrlshortenerUrlGet_593677(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Expands a short URL or gets creation time and analytics.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   shortUrl: JString (required)
  ##           : The short URL, including the protocol.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Additional information to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593790 = query.getOrDefault("fields")
  valid_593790 = validateParameter(valid_593790, JString, required = false,
                                 default = nil)
  if valid_593790 != nil:
    section.add "fields", valid_593790
  var valid_593791 = query.getOrDefault("quotaUser")
  valid_593791 = validateParameter(valid_593791, JString, required = false,
                                 default = nil)
  if valid_593791 != nil:
    section.add "quotaUser", valid_593791
  var valid_593805 = query.getOrDefault("alt")
  valid_593805 = validateParameter(valid_593805, JString, required = false,
                                 default = newJString("json"))
  if valid_593805 != nil:
    section.add "alt", valid_593805
  var valid_593806 = query.getOrDefault("oauth_token")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "oauth_token", valid_593806
  assert query != nil,
        "query argument is necessary due to required `shortUrl` field"
  var valid_593807 = query.getOrDefault("shortUrl")
  valid_593807 = validateParameter(valid_593807, JString, required = true,
                                 default = nil)
  if valid_593807 != nil:
    section.add "shortUrl", valid_593807
  var valid_593808 = query.getOrDefault("userIp")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "userIp", valid_593808
  var valid_593809 = query.getOrDefault("key")
  valid_593809 = validateParameter(valid_593809, JString, required = false,
                                 default = nil)
  if valid_593809 != nil:
    section.add "key", valid_593809
  var valid_593810 = query.getOrDefault("projection")
  valid_593810 = validateParameter(valid_593810, JString, required = false,
                                 default = newJString("ANALYTICS_CLICKS"))
  if valid_593810 != nil:
    section.add "projection", valid_593810
  var valid_593811 = query.getOrDefault("prettyPrint")
  valid_593811 = validateParameter(valid_593811, JBool, required = false,
                                 default = newJBool(true))
  if valid_593811 != nil:
    section.add "prettyPrint", valid_593811
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593834: Call_UrlshortenerUrlGet_593676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Expands a short URL or gets creation time and analytics.
  ## 
  let valid = call_593834.validator(path, query, header, formData, body)
  let scheme = call_593834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593834.url(scheme.get, call_593834.host, call_593834.base,
                         call_593834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593834, url, valid)

proc call*(call_593905: Call_UrlshortenerUrlGet_593676; shortUrl: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          projection: string = "ANALYTICS_CLICKS"; prettyPrint: bool = true): Recallable =
  ## urlshortenerUrlGet
  ## Expands a short URL or gets creation time and analytics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   shortUrl: string (required)
  ##           : The short URL, including the protocol.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Additional information to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593906 = newJObject()
  add(query_593906, "fields", newJString(fields))
  add(query_593906, "quotaUser", newJString(quotaUser))
  add(query_593906, "alt", newJString(alt))
  add(query_593906, "oauth_token", newJString(oauthToken))
  add(query_593906, "shortUrl", newJString(shortUrl))
  add(query_593906, "userIp", newJString(userIp))
  add(query_593906, "key", newJString(key))
  add(query_593906, "projection", newJString(projection))
  add(query_593906, "prettyPrint", newJBool(prettyPrint))
  result = call_593905.call(nil, query_593906, nil, nil, nil)

var urlshortenerUrlGet* = Call_UrlshortenerUrlGet_593676(
    name: "urlshortenerUrlGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/url",
    validator: validate_UrlshortenerUrlGet_593677, base: "/urlshortener/v1",
    url: url_UrlshortenerUrlGet_593678, schemes: {Scheme.Https})
type
  Call_UrlshortenerUrlList_593961 = ref object of OpenApiRestCall_593408
proc url_UrlshortenerUrlList_593963(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_UrlshortenerUrlList_593962(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves a list of URLs shortened by a user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Additional information to return.
  ##   start-token: JString
  ##              : Token for requesting successive pages of results.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593964 = query.getOrDefault("fields")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = nil)
  if valid_593964 != nil:
    section.add "fields", valid_593964
  var valid_593965 = query.getOrDefault("quotaUser")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "quotaUser", valid_593965
  var valid_593966 = query.getOrDefault("alt")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = newJString("json"))
  if valid_593966 != nil:
    section.add "alt", valid_593966
  var valid_593967 = query.getOrDefault("oauth_token")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "oauth_token", valid_593967
  var valid_593968 = query.getOrDefault("userIp")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = nil)
  if valid_593968 != nil:
    section.add "userIp", valid_593968
  var valid_593969 = query.getOrDefault("key")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "key", valid_593969
  var valid_593970 = query.getOrDefault("projection")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = newJString("ANALYTICS_CLICKS"))
  if valid_593970 != nil:
    section.add "projection", valid_593970
  var valid_593971 = query.getOrDefault("start-token")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "start-token", valid_593971
  var valid_593972 = query.getOrDefault("prettyPrint")
  valid_593972 = validateParameter(valid_593972, JBool, required = false,
                                 default = newJBool(true))
  if valid_593972 != nil:
    section.add "prettyPrint", valid_593972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593973: Call_UrlshortenerUrlList_593961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of URLs shortened by a user.
  ## 
  let valid = call_593973.validator(path, query, header, formData, body)
  let scheme = call_593973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593973.url(scheme.get, call_593973.host, call_593973.base,
                         call_593973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593973, url, valid)

proc call*(call_593974: Call_UrlshortenerUrlList_593961; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = "";
          projection: string = "ANALYTICS_CLICKS"; startToken: string = "";
          prettyPrint: bool = true): Recallable =
  ## urlshortenerUrlList
  ## Retrieves a list of URLs shortened by a user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Additional information to return.
  ##   startToken: string
  ##             : Token for requesting successive pages of results.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593975 = newJObject()
  add(query_593975, "fields", newJString(fields))
  add(query_593975, "quotaUser", newJString(quotaUser))
  add(query_593975, "alt", newJString(alt))
  add(query_593975, "oauth_token", newJString(oauthToken))
  add(query_593975, "userIp", newJString(userIp))
  add(query_593975, "key", newJString(key))
  add(query_593975, "projection", newJString(projection))
  add(query_593975, "start-token", newJString(startToken))
  add(query_593975, "prettyPrint", newJBool(prettyPrint))
  result = call_593974.call(nil, query_593975, nil, nil, nil)

var urlshortenerUrlList* = Call_UrlshortenerUrlList_593961(
    name: "urlshortenerUrlList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/url/history",
    validator: validate_UrlshortenerUrlList_593962, base: "/urlshortener/v1",
    url: url_UrlshortenerUrlList_593963, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
