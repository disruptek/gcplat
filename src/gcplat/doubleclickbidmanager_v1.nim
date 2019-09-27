
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DoubleClick Bid Manager
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## API for viewing and managing your reports in DoubleClick Bid Manager.
## 
## https://developers.google.com/bid-manager/
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
  gcpServiceName = "doubleclickbidmanager"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DoubleclickbidmanagerLineitemsDownloadlineitems_593676 = ref object of OpenApiRestCall_593408
proc url_DoubleclickbidmanagerLineitemsDownloadlineitems_593678(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DoubleclickbidmanagerLineitemsDownloadlineitems_593677(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves line items in CSV format. TrueView line items are not supported.
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
  var valid_593807 = query.getOrDefault("userIp")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "userIp", valid_593807
  var valid_593808 = query.getOrDefault("key")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "key", valid_593808
  var valid_593809 = query.getOrDefault("prettyPrint")
  valid_593809 = validateParameter(valid_593809, JBool, required = false,
                                 default = newJBool(true))
  if valid_593809 != nil:
    section.add "prettyPrint", valid_593809
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

proc call*(call_593833: Call_DoubleclickbidmanagerLineitemsDownloadlineitems_593676;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves line items in CSV format. TrueView line items are not supported.
  ## 
  let valid = call_593833.validator(path, query, header, formData, body)
  let scheme = call_593833.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593833.url(scheme.get, call_593833.host, call_593833.base,
                         call_593833.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593833, url, valid)

proc call*(call_593904: Call_DoubleclickbidmanagerLineitemsDownloadlineitems_593676;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## doubleclickbidmanagerLineitemsDownloadlineitems
  ## Retrieves line items in CSV format. TrueView line items are not supported.
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
  var query_593905 = newJObject()
  var body_593907 = newJObject()
  add(query_593905, "fields", newJString(fields))
  add(query_593905, "quotaUser", newJString(quotaUser))
  add(query_593905, "alt", newJString(alt))
  add(query_593905, "oauth_token", newJString(oauthToken))
  add(query_593905, "userIp", newJString(userIp))
  add(query_593905, "key", newJString(key))
  if body != nil:
    body_593907 = body
  add(query_593905, "prettyPrint", newJBool(prettyPrint))
  result = call_593904.call(nil, query_593905, nil, nil, body_593907)

var doubleclickbidmanagerLineitemsDownloadlineitems* = Call_DoubleclickbidmanagerLineitemsDownloadlineitems_593676(
    name: "doubleclickbidmanagerLineitemsDownloadlineitems",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/lineitems/downloadlineitems",
    validator: validate_DoubleclickbidmanagerLineitemsDownloadlineitems_593677,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerLineitemsDownloadlineitems_593678,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerLineitemsUploadlineitems_593946 = ref object of OpenApiRestCall_593408
proc url_DoubleclickbidmanagerLineitemsUploadlineitems_593948(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DoubleclickbidmanagerLineitemsUploadlineitems_593947(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Uploads line items in CSV format. TrueView line items are not supported.
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

proc call*(call_593957: Call_DoubleclickbidmanagerLineitemsUploadlineitems_593946;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads line items in CSV format. TrueView line items are not supported.
  ## 
  let valid = call_593957.validator(path, query, header, formData, body)
  let scheme = call_593957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593957.url(scheme.get, call_593957.host, call_593957.base,
                         call_593957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593957, url, valid)

proc call*(call_593958: Call_DoubleclickbidmanagerLineitemsUploadlineitems_593946;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## doubleclickbidmanagerLineitemsUploadlineitems
  ## Uploads line items in CSV format. TrueView line items are not supported.
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

var doubleclickbidmanagerLineitemsUploadlineitems* = Call_DoubleclickbidmanagerLineitemsUploadlineitems_593946(
    name: "doubleclickbidmanagerLineitemsUploadlineitems",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/lineitems/uploadlineitems",
    validator: validate_DoubleclickbidmanagerLineitemsUploadlineitems_593947,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerLineitemsUploadlineitems_593948,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesListqueries_593961 = ref object of OpenApiRestCall_593408
proc url_DoubleclickbidmanagerQueriesListqueries_593963(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DoubleclickbidmanagerQueriesListqueries_593962(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves stored queries.
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
  var valid_593970 = query.getOrDefault("prettyPrint")
  valid_593970 = validateParameter(valid_593970, JBool, required = false,
                                 default = newJBool(true))
  if valid_593970 != nil:
    section.add "prettyPrint", valid_593970
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593971: Call_DoubleclickbidmanagerQueriesListqueries_593961;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves stored queries.
  ## 
  let valid = call_593971.validator(path, query, header, formData, body)
  let scheme = call_593971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593971.url(scheme.get, call_593971.host, call_593971.base,
                         call_593971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593971, url, valid)

proc call*(call_593972: Call_DoubleclickbidmanagerQueriesListqueries_593961;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## doubleclickbidmanagerQueriesListqueries
  ## Retrieves stored queries.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593973 = newJObject()
  add(query_593973, "fields", newJString(fields))
  add(query_593973, "quotaUser", newJString(quotaUser))
  add(query_593973, "alt", newJString(alt))
  add(query_593973, "oauth_token", newJString(oauthToken))
  add(query_593973, "userIp", newJString(userIp))
  add(query_593973, "key", newJString(key))
  add(query_593973, "prettyPrint", newJBool(prettyPrint))
  result = call_593972.call(nil, query_593973, nil, nil, nil)

var doubleclickbidmanagerQueriesListqueries* = Call_DoubleclickbidmanagerQueriesListqueries_593961(
    name: "doubleclickbidmanagerQueriesListqueries", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/queries",
    validator: validate_DoubleclickbidmanagerQueriesListqueries_593962,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesListqueries_593963,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerReportsListreports_593974 = ref object of OpenApiRestCall_593408
proc url_DoubleclickbidmanagerReportsListreports_593976(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "queryId" in path, "`queryId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/queries/"),
               (kind: VariableSegment, value: "queryId"),
               (kind: ConstantSegment, value: "/reports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DoubleclickbidmanagerReportsListreports_593975(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves stored reports.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   queryId: JString (required)
  ##          : Query ID with which the reports are associated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `queryId` field"
  var valid_593991 = path.getOrDefault("queryId")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "queryId", valid_593991
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
  var valid_593992 = query.getOrDefault("fields")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "fields", valid_593992
  var valid_593993 = query.getOrDefault("quotaUser")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "quotaUser", valid_593993
  var valid_593994 = query.getOrDefault("alt")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = newJString("json"))
  if valid_593994 != nil:
    section.add "alt", valid_593994
  var valid_593995 = query.getOrDefault("oauth_token")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "oauth_token", valid_593995
  var valid_593996 = query.getOrDefault("userIp")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "userIp", valid_593996
  var valid_593997 = query.getOrDefault("key")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "key", valid_593997
  var valid_593998 = query.getOrDefault("prettyPrint")
  valid_593998 = validateParameter(valid_593998, JBool, required = false,
                                 default = newJBool(true))
  if valid_593998 != nil:
    section.add "prettyPrint", valid_593998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593999: Call_DoubleclickbidmanagerReportsListreports_593974;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves stored reports.
  ## 
  let valid = call_593999.validator(path, query, header, formData, body)
  let scheme = call_593999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593999.url(scheme.get, call_593999.host, call_593999.base,
                         call_593999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593999, url, valid)

proc call*(call_594000: Call_DoubleclickbidmanagerReportsListreports_593974;
          queryId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## doubleclickbidmanagerReportsListreports
  ## Retrieves stored reports.
  ##   queryId: string (required)
  ##          : Query ID with which the reports are associated.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594001 = newJObject()
  var query_594002 = newJObject()
  add(path_594001, "queryId", newJString(queryId))
  add(query_594002, "fields", newJString(fields))
  add(query_594002, "quotaUser", newJString(quotaUser))
  add(query_594002, "alt", newJString(alt))
  add(query_594002, "oauth_token", newJString(oauthToken))
  add(query_594002, "userIp", newJString(userIp))
  add(query_594002, "key", newJString(key))
  add(query_594002, "prettyPrint", newJBool(prettyPrint))
  result = call_594000.call(path_594001, query_594002, nil, nil, nil)

var doubleclickbidmanagerReportsListreports* = Call_DoubleclickbidmanagerReportsListreports_593974(
    name: "doubleclickbidmanagerReportsListreports", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/queries/{queryId}/reports",
    validator: validate_DoubleclickbidmanagerReportsListreports_593975,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerReportsListreports_593976,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesCreatequery_594003 = ref object of OpenApiRestCall_593408
proc url_DoubleclickbidmanagerQueriesCreatequery_594005(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DoubleclickbidmanagerQueriesCreatequery_594004(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a query.
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
  var valid_594006 = query.getOrDefault("fields")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "fields", valid_594006
  var valid_594007 = query.getOrDefault("quotaUser")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "quotaUser", valid_594007
  var valid_594008 = query.getOrDefault("alt")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = newJString("json"))
  if valid_594008 != nil:
    section.add "alt", valid_594008
  var valid_594009 = query.getOrDefault("oauth_token")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "oauth_token", valid_594009
  var valid_594010 = query.getOrDefault("userIp")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "userIp", valid_594010
  var valid_594011 = query.getOrDefault("key")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "key", valid_594011
  var valid_594012 = query.getOrDefault("prettyPrint")
  valid_594012 = validateParameter(valid_594012, JBool, required = false,
                                 default = newJBool(true))
  if valid_594012 != nil:
    section.add "prettyPrint", valid_594012
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

proc call*(call_594014: Call_DoubleclickbidmanagerQueriesCreatequery_594003;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a query.
  ## 
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_DoubleclickbidmanagerQueriesCreatequery_594003;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## doubleclickbidmanagerQueriesCreatequery
  ## Creates a query.
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
  var query_594016 = newJObject()
  var body_594017 = newJObject()
  add(query_594016, "fields", newJString(fields))
  add(query_594016, "quotaUser", newJString(quotaUser))
  add(query_594016, "alt", newJString(alt))
  add(query_594016, "oauth_token", newJString(oauthToken))
  add(query_594016, "userIp", newJString(userIp))
  add(query_594016, "key", newJString(key))
  if body != nil:
    body_594017 = body
  add(query_594016, "prettyPrint", newJBool(prettyPrint))
  result = call_594015.call(nil, query_594016, nil, nil, body_594017)

var doubleclickbidmanagerQueriesCreatequery* = Call_DoubleclickbidmanagerQueriesCreatequery_594003(
    name: "doubleclickbidmanagerQueriesCreatequery", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/query",
    validator: validate_DoubleclickbidmanagerQueriesCreatequery_594004,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesCreatequery_594005,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesRunquery_594033 = ref object of OpenApiRestCall_593408
proc url_DoubleclickbidmanagerQueriesRunquery_594035(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "queryId" in path, "`queryId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/query/"),
               (kind: VariableSegment, value: "queryId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DoubleclickbidmanagerQueriesRunquery_594034(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Runs a stored query to generate a report.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   queryId: JString (required)
  ##          : Query ID to run.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `queryId` field"
  var valid_594036 = path.getOrDefault("queryId")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "queryId", valid_594036
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
  var valid_594037 = query.getOrDefault("fields")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "fields", valid_594037
  var valid_594038 = query.getOrDefault("quotaUser")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "quotaUser", valid_594038
  var valid_594039 = query.getOrDefault("alt")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = newJString("json"))
  if valid_594039 != nil:
    section.add "alt", valid_594039
  var valid_594040 = query.getOrDefault("oauth_token")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "oauth_token", valid_594040
  var valid_594041 = query.getOrDefault("userIp")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "userIp", valid_594041
  var valid_594042 = query.getOrDefault("key")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "key", valid_594042
  var valid_594043 = query.getOrDefault("prettyPrint")
  valid_594043 = validateParameter(valid_594043, JBool, required = false,
                                 default = newJBool(true))
  if valid_594043 != nil:
    section.add "prettyPrint", valid_594043
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

proc call*(call_594045: Call_DoubleclickbidmanagerQueriesRunquery_594033;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Runs a stored query to generate a report.
  ## 
  let valid = call_594045.validator(path, query, header, formData, body)
  let scheme = call_594045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594045.url(scheme.get, call_594045.host, call_594045.base,
                         call_594045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594045, url, valid)

proc call*(call_594046: Call_DoubleclickbidmanagerQueriesRunquery_594033;
          queryId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## doubleclickbidmanagerQueriesRunquery
  ## Runs a stored query to generate a report.
  ##   queryId: string (required)
  ##          : Query ID to run.
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
  var path_594047 = newJObject()
  var query_594048 = newJObject()
  var body_594049 = newJObject()
  add(path_594047, "queryId", newJString(queryId))
  add(query_594048, "fields", newJString(fields))
  add(query_594048, "quotaUser", newJString(quotaUser))
  add(query_594048, "alt", newJString(alt))
  add(query_594048, "oauth_token", newJString(oauthToken))
  add(query_594048, "userIp", newJString(userIp))
  add(query_594048, "key", newJString(key))
  if body != nil:
    body_594049 = body
  add(query_594048, "prettyPrint", newJBool(prettyPrint))
  result = call_594046.call(path_594047, query_594048, nil, nil, body_594049)

var doubleclickbidmanagerQueriesRunquery* = Call_DoubleclickbidmanagerQueriesRunquery_594033(
    name: "doubleclickbidmanagerQueriesRunquery", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/query/{queryId}",
    validator: validate_DoubleclickbidmanagerQueriesRunquery_594034,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesRunquery_594035, schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesGetquery_594018 = ref object of OpenApiRestCall_593408
proc url_DoubleclickbidmanagerQueriesGetquery_594020(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "queryId" in path, "`queryId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/query/"),
               (kind: VariableSegment, value: "queryId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DoubleclickbidmanagerQueriesGetquery_594019(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a stored query.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   queryId: JString (required)
  ##          : Query ID to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `queryId` field"
  var valid_594021 = path.getOrDefault("queryId")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "queryId", valid_594021
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
  var valid_594022 = query.getOrDefault("fields")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "fields", valid_594022
  var valid_594023 = query.getOrDefault("quotaUser")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "quotaUser", valid_594023
  var valid_594024 = query.getOrDefault("alt")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = newJString("json"))
  if valid_594024 != nil:
    section.add "alt", valid_594024
  var valid_594025 = query.getOrDefault("oauth_token")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "oauth_token", valid_594025
  var valid_594026 = query.getOrDefault("userIp")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "userIp", valid_594026
  var valid_594027 = query.getOrDefault("key")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "key", valid_594027
  var valid_594028 = query.getOrDefault("prettyPrint")
  valid_594028 = validateParameter(valid_594028, JBool, required = false,
                                 default = newJBool(true))
  if valid_594028 != nil:
    section.add "prettyPrint", valid_594028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594029: Call_DoubleclickbidmanagerQueriesGetquery_594018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a stored query.
  ## 
  let valid = call_594029.validator(path, query, header, formData, body)
  let scheme = call_594029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594029.url(scheme.get, call_594029.host, call_594029.base,
                         call_594029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594029, url, valid)

proc call*(call_594030: Call_DoubleclickbidmanagerQueriesGetquery_594018;
          queryId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## doubleclickbidmanagerQueriesGetquery
  ## Retrieves a stored query.
  ##   queryId: string (required)
  ##          : Query ID to retrieve.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594031 = newJObject()
  var query_594032 = newJObject()
  add(path_594031, "queryId", newJString(queryId))
  add(query_594032, "fields", newJString(fields))
  add(query_594032, "quotaUser", newJString(quotaUser))
  add(query_594032, "alt", newJString(alt))
  add(query_594032, "oauth_token", newJString(oauthToken))
  add(query_594032, "userIp", newJString(userIp))
  add(query_594032, "key", newJString(key))
  add(query_594032, "prettyPrint", newJBool(prettyPrint))
  result = call_594030.call(path_594031, query_594032, nil, nil, nil)

var doubleclickbidmanagerQueriesGetquery* = Call_DoubleclickbidmanagerQueriesGetquery_594018(
    name: "doubleclickbidmanagerQueriesGetquery", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/query/{queryId}",
    validator: validate_DoubleclickbidmanagerQueriesGetquery_594019,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesGetquery_594020, schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesDeletequery_594050 = ref object of OpenApiRestCall_593408
proc url_DoubleclickbidmanagerQueriesDeletequery_594052(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "queryId" in path, "`queryId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/query/"),
               (kind: VariableSegment, value: "queryId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DoubleclickbidmanagerQueriesDeletequery_594051(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a stored query as well as the associated stored reports.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   queryId: JString (required)
  ##          : Query ID to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `queryId` field"
  var valid_594053 = path.getOrDefault("queryId")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "queryId", valid_594053
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
  var valid_594054 = query.getOrDefault("fields")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "fields", valid_594054
  var valid_594055 = query.getOrDefault("quotaUser")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "quotaUser", valid_594055
  var valid_594056 = query.getOrDefault("alt")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = newJString("json"))
  if valid_594056 != nil:
    section.add "alt", valid_594056
  var valid_594057 = query.getOrDefault("oauth_token")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "oauth_token", valid_594057
  var valid_594058 = query.getOrDefault("userIp")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "userIp", valid_594058
  var valid_594059 = query.getOrDefault("key")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "key", valid_594059
  var valid_594060 = query.getOrDefault("prettyPrint")
  valid_594060 = validateParameter(valid_594060, JBool, required = false,
                                 default = newJBool(true))
  if valid_594060 != nil:
    section.add "prettyPrint", valid_594060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594061: Call_DoubleclickbidmanagerQueriesDeletequery_594050;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a stored query as well as the associated stored reports.
  ## 
  let valid = call_594061.validator(path, query, header, formData, body)
  let scheme = call_594061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594061.url(scheme.get, call_594061.host, call_594061.base,
                         call_594061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594061, url, valid)

proc call*(call_594062: Call_DoubleclickbidmanagerQueriesDeletequery_594050;
          queryId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## doubleclickbidmanagerQueriesDeletequery
  ## Deletes a stored query as well as the associated stored reports.
  ##   queryId: string (required)
  ##          : Query ID to delete.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594063 = newJObject()
  var query_594064 = newJObject()
  add(path_594063, "queryId", newJString(queryId))
  add(query_594064, "fields", newJString(fields))
  add(query_594064, "quotaUser", newJString(quotaUser))
  add(query_594064, "alt", newJString(alt))
  add(query_594064, "oauth_token", newJString(oauthToken))
  add(query_594064, "userIp", newJString(userIp))
  add(query_594064, "key", newJString(key))
  add(query_594064, "prettyPrint", newJBool(prettyPrint))
  result = call_594062.call(path_594063, query_594064, nil, nil, nil)

var doubleclickbidmanagerQueriesDeletequery* = Call_DoubleclickbidmanagerQueriesDeletequery_594050(
    name: "doubleclickbidmanagerQueriesDeletequery", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/query/{queryId}",
    validator: validate_DoubleclickbidmanagerQueriesDeletequery_594051,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesDeletequery_594052,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerSdfDownload_594065 = ref object of OpenApiRestCall_593408
proc url_DoubleclickbidmanagerSdfDownload_594067(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DoubleclickbidmanagerSdfDownload_594066(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves entities in SDF format.
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
  var valid_594068 = query.getOrDefault("fields")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "fields", valid_594068
  var valid_594069 = query.getOrDefault("quotaUser")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "quotaUser", valid_594069
  var valid_594070 = query.getOrDefault("alt")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = newJString("json"))
  if valid_594070 != nil:
    section.add "alt", valid_594070
  var valid_594071 = query.getOrDefault("oauth_token")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "oauth_token", valid_594071
  var valid_594072 = query.getOrDefault("userIp")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "userIp", valid_594072
  var valid_594073 = query.getOrDefault("key")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "key", valid_594073
  var valid_594074 = query.getOrDefault("prettyPrint")
  valid_594074 = validateParameter(valid_594074, JBool, required = false,
                                 default = newJBool(true))
  if valid_594074 != nil:
    section.add "prettyPrint", valid_594074
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

proc call*(call_594076: Call_DoubleclickbidmanagerSdfDownload_594065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves entities in SDF format.
  ## 
  let valid = call_594076.validator(path, query, header, formData, body)
  let scheme = call_594076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594076.url(scheme.get, call_594076.host, call_594076.base,
                         call_594076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594076, url, valid)

proc call*(call_594077: Call_DoubleclickbidmanagerSdfDownload_594065;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## doubleclickbidmanagerSdfDownload
  ## Retrieves entities in SDF format.
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
  var query_594078 = newJObject()
  var body_594079 = newJObject()
  add(query_594078, "fields", newJString(fields))
  add(query_594078, "quotaUser", newJString(quotaUser))
  add(query_594078, "alt", newJString(alt))
  add(query_594078, "oauth_token", newJString(oauthToken))
  add(query_594078, "userIp", newJString(userIp))
  add(query_594078, "key", newJString(key))
  if body != nil:
    body_594079 = body
  add(query_594078, "prettyPrint", newJBool(prettyPrint))
  result = call_594077.call(nil, query_594078, nil, nil, body_594079)

var doubleclickbidmanagerSdfDownload* = Call_DoubleclickbidmanagerSdfDownload_594065(
    name: "doubleclickbidmanagerSdfDownload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/sdf/download",
    validator: validate_DoubleclickbidmanagerSdfDownload_594066,
    base: "/doubleclickbidmanager/v1", url: url_DoubleclickbidmanagerSdfDownload_594067,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
