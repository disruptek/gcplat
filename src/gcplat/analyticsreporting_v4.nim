
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Analytics Reporting
## version: v4
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Accesses Analytics report data.
## 
## https://developers.google.com/analytics/devguides/reporting/core/v4/
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

  OpenApiRestCall_597421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597421): Option[Scheme] {.used.} =
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
  gcpServiceName = "analyticsreporting"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AnalyticsreportingReportsBatchGet_597690 = ref object of OpenApiRestCall_597421
proc url_AnalyticsreportingReportsBatchGet_597692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AnalyticsreportingReportsBatchGet_597691(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the Analytics data.
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
  var valid_597804 = query.getOrDefault("upload_protocol")
  valid_597804 = validateParameter(valid_597804, JString, required = false,
                                 default = nil)
  if valid_597804 != nil:
    section.add "upload_protocol", valid_597804
  var valid_597805 = query.getOrDefault("fields")
  valid_597805 = validateParameter(valid_597805, JString, required = false,
                                 default = nil)
  if valid_597805 != nil:
    section.add "fields", valid_597805
  var valid_597806 = query.getOrDefault("quotaUser")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "quotaUser", valid_597806
  var valid_597820 = query.getOrDefault("alt")
  valid_597820 = validateParameter(valid_597820, JString, required = false,
                                 default = newJString("json"))
  if valid_597820 != nil:
    section.add "alt", valid_597820
  var valid_597821 = query.getOrDefault("oauth_token")
  valid_597821 = validateParameter(valid_597821, JString, required = false,
                                 default = nil)
  if valid_597821 != nil:
    section.add "oauth_token", valid_597821
  var valid_597822 = query.getOrDefault("callback")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = nil)
  if valid_597822 != nil:
    section.add "callback", valid_597822
  var valid_597823 = query.getOrDefault("access_token")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "access_token", valid_597823
  var valid_597824 = query.getOrDefault("uploadType")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "uploadType", valid_597824
  var valid_597825 = query.getOrDefault("key")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "key", valid_597825
  var valid_597826 = query.getOrDefault("$.xgafv")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = newJString("1"))
  if valid_597826 != nil:
    section.add "$.xgafv", valid_597826
  var valid_597827 = query.getOrDefault("prettyPrint")
  valid_597827 = validateParameter(valid_597827, JBool, required = false,
                                 default = newJBool(true))
  if valid_597827 != nil:
    section.add "prettyPrint", valid_597827
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

proc call*(call_597851: Call_AnalyticsreportingReportsBatchGet_597690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the Analytics data.
  ## 
  let valid = call_597851.validator(path, query, header, formData, body)
  let scheme = call_597851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597851.url(scheme.get, call_597851.host, call_597851.base,
                         call_597851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597851, url, valid)

proc call*(call_597922: Call_AnalyticsreportingReportsBatchGet_597690;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## analyticsreportingReportsBatchGet
  ## Returns the Analytics data.
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
  var query_597923 = newJObject()
  var body_597925 = newJObject()
  add(query_597923, "upload_protocol", newJString(uploadProtocol))
  add(query_597923, "fields", newJString(fields))
  add(query_597923, "quotaUser", newJString(quotaUser))
  add(query_597923, "alt", newJString(alt))
  add(query_597923, "oauth_token", newJString(oauthToken))
  add(query_597923, "callback", newJString(callback))
  add(query_597923, "access_token", newJString(accessToken))
  add(query_597923, "uploadType", newJString(uploadType))
  add(query_597923, "key", newJString(key))
  add(query_597923, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597925 = body
  add(query_597923, "prettyPrint", newJBool(prettyPrint))
  result = call_597922.call(nil, query_597923, nil, nil, body_597925)

var analyticsreportingReportsBatchGet* = Call_AnalyticsreportingReportsBatchGet_597690(
    name: "analyticsreportingReportsBatchGet", meth: HttpMethod.HttpPost,
    host: "analyticsreporting.googleapis.com", route: "/v4/reports:batchGet",
    validator: validate_AnalyticsreportingReportsBatchGet_597691, base: "/",
    url: url_AnalyticsreportingReportsBatchGet_597692, schemes: {Scheme.Https})
type
  Call_AnalyticsreportingUserActivitySearch_597964 = ref object of OpenApiRestCall_597421
proc url_AnalyticsreportingUserActivitySearch_597966(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AnalyticsreportingUserActivitySearch_597965(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns User Activity data.
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
  var valid_597967 = query.getOrDefault("upload_protocol")
  valid_597967 = validateParameter(valid_597967, JString, required = false,
                                 default = nil)
  if valid_597967 != nil:
    section.add "upload_protocol", valid_597967
  var valid_597968 = query.getOrDefault("fields")
  valid_597968 = validateParameter(valid_597968, JString, required = false,
                                 default = nil)
  if valid_597968 != nil:
    section.add "fields", valid_597968
  var valid_597969 = query.getOrDefault("quotaUser")
  valid_597969 = validateParameter(valid_597969, JString, required = false,
                                 default = nil)
  if valid_597969 != nil:
    section.add "quotaUser", valid_597969
  var valid_597970 = query.getOrDefault("alt")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = newJString("json"))
  if valid_597970 != nil:
    section.add "alt", valid_597970
  var valid_597971 = query.getOrDefault("oauth_token")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "oauth_token", valid_597971
  var valid_597972 = query.getOrDefault("callback")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = nil)
  if valid_597972 != nil:
    section.add "callback", valid_597972
  var valid_597973 = query.getOrDefault("access_token")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "access_token", valid_597973
  var valid_597974 = query.getOrDefault("uploadType")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "uploadType", valid_597974
  var valid_597975 = query.getOrDefault("key")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "key", valid_597975
  var valid_597976 = query.getOrDefault("$.xgafv")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = newJString("1"))
  if valid_597976 != nil:
    section.add "$.xgafv", valid_597976
  var valid_597977 = query.getOrDefault("prettyPrint")
  valid_597977 = validateParameter(valid_597977, JBool, required = false,
                                 default = newJBool(true))
  if valid_597977 != nil:
    section.add "prettyPrint", valid_597977
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

proc call*(call_597979: Call_AnalyticsreportingUserActivitySearch_597964;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns User Activity data.
  ## 
  let valid = call_597979.validator(path, query, header, formData, body)
  let scheme = call_597979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597979.url(scheme.get, call_597979.host, call_597979.base,
                         call_597979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597979, url, valid)

proc call*(call_597980: Call_AnalyticsreportingUserActivitySearch_597964;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## analyticsreportingUserActivitySearch
  ## Returns User Activity data.
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
  var query_597981 = newJObject()
  var body_597982 = newJObject()
  add(query_597981, "upload_protocol", newJString(uploadProtocol))
  add(query_597981, "fields", newJString(fields))
  add(query_597981, "quotaUser", newJString(quotaUser))
  add(query_597981, "alt", newJString(alt))
  add(query_597981, "oauth_token", newJString(oauthToken))
  add(query_597981, "callback", newJString(callback))
  add(query_597981, "access_token", newJString(accessToken))
  add(query_597981, "uploadType", newJString(uploadType))
  add(query_597981, "key", newJString(key))
  add(query_597981, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597982 = body
  add(query_597981, "prettyPrint", newJBool(prettyPrint))
  result = call_597980.call(nil, query_597981, nil, nil, body_597982)

var analyticsreportingUserActivitySearch* = Call_AnalyticsreportingUserActivitySearch_597964(
    name: "analyticsreportingUserActivitySearch", meth: HttpMethod.HttpPost,
    host: "analyticsreporting.googleapis.com", route: "/v4/userActivity:search",
    validator: validate_AnalyticsreportingUserActivitySearch_597965, base: "/",
    url: url_AnalyticsreportingUserActivitySearch_597966, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
