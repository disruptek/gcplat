
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Stackdriver Logging
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Writes log entries and manages your Stackdriver Logging configuration. The table entries below are presented in alphabetical order, not in order of common use. For explanations of the concepts found in the table entries, read the Stackdriver Logging documentation.
## 
## https://cloud.google.com/logging/docs/
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
  gcpServiceName = "logging"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LoggingEntriesList_579677 = ref object of OpenApiRestCall_579408
proc url_LoggingEntriesList_579679(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_LoggingEntriesList_579678(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists log entries. Use this method to retrieve log entries that originated from a project/folder/organization/billing account. For ways to export log entries, see Exporting Logs.
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
  var valid_579808 = query.getOrDefault("oauth_token")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "oauth_token", valid_579808
  var valid_579809 = query.getOrDefault("callback")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "callback", valid_579809
  var valid_579810 = query.getOrDefault("access_token")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "access_token", valid_579810
  var valid_579811 = query.getOrDefault("uploadType")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "uploadType", valid_579811
  var valid_579812 = query.getOrDefault("key")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "key", valid_579812
  var valid_579813 = query.getOrDefault("$.xgafv")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = newJString("1"))
  if valid_579813 != nil:
    section.add "$.xgafv", valid_579813
  var valid_579814 = query.getOrDefault("prettyPrint")
  valid_579814 = validateParameter(valid_579814, JBool, required = false,
                                 default = newJBool(true))
  if valid_579814 != nil:
    section.add "prettyPrint", valid_579814
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

proc call*(call_579838: Call_LoggingEntriesList_579677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists log entries. Use this method to retrieve log entries that originated from a project/folder/organization/billing account. For ways to export log entries, see Exporting Logs.
  ## 
  let valid = call_579838.validator(path, query, header, formData, body)
  let scheme = call_579838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579838.url(scheme.get, call_579838.host, call_579838.base,
                         call_579838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579838, url, valid)

proc call*(call_579909: Call_LoggingEntriesList_579677;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## loggingEntriesList
  ## Lists log entries. Use this method to retrieve log entries that originated from a project/folder/organization/billing account. For ways to export log entries, see Exporting Logs.
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
  var query_579910 = newJObject()
  var body_579912 = newJObject()
  add(query_579910, "upload_protocol", newJString(uploadProtocol))
  add(query_579910, "fields", newJString(fields))
  add(query_579910, "quotaUser", newJString(quotaUser))
  add(query_579910, "alt", newJString(alt))
  add(query_579910, "oauth_token", newJString(oauthToken))
  add(query_579910, "callback", newJString(callback))
  add(query_579910, "access_token", newJString(accessToken))
  add(query_579910, "uploadType", newJString(uploadType))
  add(query_579910, "key", newJString(key))
  add(query_579910, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579912 = body
  add(query_579910, "prettyPrint", newJBool(prettyPrint))
  result = call_579909.call(nil, query_579910, nil, nil, body_579912)

var loggingEntriesList* = Call_LoggingEntriesList_579677(
    name: "loggingEntriesList", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2/entries:list",
    validator: validate_LoggingEntriesList_579678, base: "/",
    url: url_LoggingEntriesList_579679, schemes: {Scheme.Https})
type
  Call_LoggingEntriesWrite_579951 = ref object of OpenApiRestCall_579408
proc url_LoggingEntriesWrite_579953(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_LoggingEntriesWrite_579952(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Writes log entries to Logging. This API method is the only way to send log entries to Logging. This method is used, directly or indirectly, by the Logging agent (fluentd) and all logging libraries configured to use Logging. A single request may contain log entries for a maximum of 1000 different resources (projects, organizations, billing accounts or folders)
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
  var valid_579954 = query.getOrDefault("upload_protocol")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "upload_protocol", valid_579954
  var valid_579955 = query.getOrDefault("fields")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "fields", valid_579955
  var valid_579956 = query.getOrDefault("quotaUser")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "quotaUser", valid_579956
  var valid_579957 = query.getOrDefault("alt")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = newJString("json"))
  if valid_579957 != nil:
    section.add "alt", valid_579957
  var valid_579958 = query.getOrDefault("oauth_token")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = nil)
  if valid_579958 != nil:
    section.add "oauth_token", valid_579958
  var valid_579959 = query.getOrDefault("callback")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "callback", valid_579959
  var valid_579960 = query.getOrDefault("access_token")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "access_token", valid_579960
  var valid_579961 = query.getOrDefault("uploadType")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "uploadType", valid_579961
  var valid_579962 = query.getOrDefault("key")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "key", valid_579962
  var valid_579963 = query.getOrDefault("$.xgafv")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = newJString("1"))
  if valid_579963 != nil:
    section.add "$.xgafv", valid_579963
  var valid_579964 = query.getOrDefault("prettyPrint")
  valid_579964 = validateParameter(valid_579964, JBool, required = false,
                                 default = newJBool(true))
  if valid_579964 != nil:
    section.add "prettyPrint", valid_579964
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

proc call*(call_579966: Call_LoggingEntriesWrite_579951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Writes log entries to Logging. This API method is the only way to send log entries to Logging. This method is used, directly or indirectly, by the Logging agent (fluentd) and all logging libraries configured to use Logging. A single request may contain log entries for a maximum of 1000 different resources (projects, organizations, billing accounts or folders)
  ## 
  let valid = call_579966.validator(path, query, header, formData, body)
  let scheme = call_579966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579966.url(scheme.get, call_579966.host, call_579966.base,
                         call_579966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579966, url, valid)

proc call*(call_579967: Call_LoggingEntriesWrite_579951;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## loggingEntriesWrite
  ## Writes log entries to Logging. This API method is the only way to send log entries to Logging. This method is used, directly or indirectly, by the Logging agent (fluentd) and all logging libraries configured to use Logging. A single request may contain log entries for a maximum of 1000 different resources (projects, organizations, billing accounts or folders)
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
  var query_579968 = newJObject()
  var body_579969 = newJObject()
  add(query_579968, "upload_protocol", newJString(uploadProtocol))
  add(query_579968, "fields", newJString(fields))
  add(query_579968, "quotaUser", newJString(quotaUser))
  add(query_579968, "alt", newJString(alt))
  add(query_579968, "oauth_token", newJString(oauthToken))
  add(query_579968, "callback", newJString(callback))
  add(query_579968, "access_token", newJString(accessToken))
  add(query_579968, "uploadType", newJString(uploadType))
  add(query_579968, "key", newJString(key))
  add(query_579968, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579969 = body
  add(query_579968, "prettyPrint", newJBool(prettyPrint))
  result = call_579967.call(nil, query_579968, nil, nil, body_579969)

var loggingEntriesWrite* = Call_LoggingEntriesWrite_579951(
    name: "loggingEntriesWrite", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2/entries:write",
    validator: validate_LoggingEntriesWrite_579952, base: "/",
    url: url_LoggingEntriesWrite_579953, schemes: {Scheme.Https})
type
  Call_LoggingMonitoredResourceDescriptorsList_579970 = ref object of OpenApiRestCall_579408
proc url_LoggingMonitoredResourceDescriptorsList_579972(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_LoggingMonitoredResourceDescriptorsList_579971(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the descriptors for monitored resource types used by Logging.
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
  ##   pageToken: JString
  ##            : Optional. If present, then retrieve the next batch of results from the preceding call to this method. pageToken must be the value of nextPageToken from the previous response. The values of other method parameters should be identical to those in the previous call.
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
  ##   pageSize: JInt
  ##           : Optional. The maximum number of results to return from this request. Non-positive values are ignored. The presence of nextPageToken in the response indicates that more results might be available.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579973 = query.getOrDefault("upload_protocol")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "upload_protocol", valid_579973
  var valid_579974 = query.getOrDefault("fields")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "fields", valid_579974
  var valid_579975 = query.getOrDefault("pageToken")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "pageToken", valid_579975
  var valid_579976 = query.getOrDefault("quotaUser")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "quotaUser", valid_579976
  var valid_579977 = query.getOrDefault("alt")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = newJString("json"))
  if valid_579977 != nil:
    section.add "alt", valid_579977
  var valid_579978 = query.getOrDefault("oauth_token")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "oauth_token", valid_579978
  var valid_579979 = query.getOrDefault("callback")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "callback", valid_579979
  var valid_579980 = query.getOrDefault("access_token")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "access_token", valid_579980
  var valid_579981 = query.getOrDefault("uploadType")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "uploadType", valid_579981
  var valid_579982 = query.getOrDefault("key")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "key", valid_579982
  var valid_579983 = query.getOrDefault("$.xgafv")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = newJString("1"))
  if valid_579983 != nil:
    section.add "$.xgafv", valid_579983
  var valid_579984 = query.getOrDefault("pageSize")
  valid_579984 = validateParameter(valid_579984, JInt, required = false, default = nil)
  if valid_579984 != nil:
    section.add "pageSize", valid_579984
  var valid_579985 = query.getOrDefault("prettyPrint")
  valid_579985 = validateParameter(valid_579985, JBool, required = false,
                                 default = newJBool(true))
  if valid_579985 != nil:
    section.add "prettyPrint", valid_579985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579986: Call_LoggingMonitoredResourceDescriptorsList_579970;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the descriptors for monitored resource types used by Logging.
  ## 
  let valid = call_579986.validator(path, query, header, formData, body)
  let scheme = call_579986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579986.url(scheme.get, call_579986.host, call_579986.base,
                         call_579986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579986, url, valid)

proc call*(call_579987: Call_LoggingMonitoredResourceDescriptorsList_579970;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## loggingMonitoredResourceDescriptorsList
  ## Lists the descriptors for monitored resource types used by Logging.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. If present, then retrieve the next batch of results from the preceding call to this method. pageToken must be the value of nextPageToken from the previous response. The values of other method parameters should be identical to those in the previous call.
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
  ##   pageSize: int
  ##           : Optional. The maximum number of results to return from this request. Non-positive values are ignored. The presence of nextPageToken in the response indicates that more results might be available.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579988 = newJObject()
  add(query_579988, "upload_protocol", newJString(uploadProtocol))
  add(query_579988, "fields", newJString(fields))
  add(query_579988, "pageToken", newJString(pageToken))
  add(query_579988, "quotaUser", newJString(quotaUser))
  add(query_579988, "alt", newJString(alt))
  add(query_579988, "oauth_token", newJString(oauthToken))
  add(query_579988, "callback", newJString(callback))
  add(query_579988, "access_token", newJString(accessToken))
  add(query_579988, "uploadType", newJString(uploadType))
  add(query_579988, "key", newJString(key))
  add(query_579988, "$.xgafv", newJString(Xgafv))
  add(query_579988, "pageSize", newJInt(pageSize))
  add(query_579988, "prettyPrint", newJBool(prettyPrint))
  result = call_579987.call(nil, query_579988, nil, nil, nil)

var loggingMonitoredResourceDescriptorsList* = Call_LoggingMonitoredResourceDescriptorsList_579970(
    name: "loggingMonitoredResourceDescriptorsList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/monitoredResourceDescriptors",
    validator: validate_LoggingMonitoredResourceDescriptorsList_579971, base: "/",
    url: url_LoggingMonitoredResourceDescriptorsList_579972,
    schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsLogsDelete_579989 = ref object of OpenApiRestCall_579408
proc url_LoggingBillingAccountsLogsDelete_579991(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "logName" in path, "`logName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "logName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingBillingAccountsLogsDelete_579990(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes all the log entries in a log. The log reappears if it receives new entries. Log entries written shortly before the delete operation might not be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   logName: JString (required)
  ##          : Required. The resource name of the log to delete:
  ## "projects/[PROJECT_ID]/logs/[LOG_ID]"
  ## "organizations/[ORGANIZATION_ID]/logs/[LOG_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/logs/[LOG_ID]"
  ## "folders/[FOLDER_ID]/logs/[LOG_ID]"
  ## [LOG_ID] must be URL-encoded. For example, "projects/my-project-id/logs/syslog", 
  ## "organizations/1234567890/logs/cloudresourcemanager.googleapis.com%2Factivity". For more information about log names, see LogEntry.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `logName` field"
  var valid_580006 = path.getOrDefault("logName")
  valid_580006 = validateParameter(valid_580006, JString, required = true,
                                 default = nil)
  if valid_580006 != nil:
    section.add "logName", valid_580006
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
  var valid_580007 = query.getOrDefault("upload_protocol")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "upload_protocol", valid_580007
  var valid_580008 = query.getOrDefault("fields")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "fields", valid_580008
  var valid_580009 = query.getOrDefault("quotaUser")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "quotaUser", valid_580009
  var valid_580010 = query.getOrDefault("alt")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = newJString("json"))
  if valid_580010 != nil:
    section.add "alt", valid_580010
  var valid_580011 = query.getOrDefault("oauth_token")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "oauth_token", valid_580011
  var valid_580012 = query.getOrDefault("callback")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "callback", valid_580012
  var valid_580013 = query.getOrDefault("access_token")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "access_token", valid_580013
  var valid_580014 = query.getOrDefault("uploadType")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "uploadType", valid_580014
  var valid_580015 = query.getOrDefault("key")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "key", valid_580015
  var valid_580016 = query.getOrDefault("$.xgafv")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = newJString("1"))
  if valid_580016 != nil:
    section.add "$.xgafv", valid_580016
  var valid_580017 = query.getOrDefault("prettyPrint")
  valid_580017 = validateParameter(valid_580017, JBool, required = false,
                                 default = newJBool(true))
  if valid_580017 != nil:
    section.add "prettyPrint", valid_580017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580018: Call_LoggingBillingAccountsLogsDelete_579989;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all the log entries in a log. The log reappears if it receives new entries. Log entries written shortly before the delete operation might not be deleted.
  ## 
  let valid = call_580018.validator(path, query, header, formData, body)
  let scheme = call_580018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580018.url(scheme.get, call_580018.host, call_580018.base,
                         call_580018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580018, url, valid)

proc call*(call_580019: Call_LoggingBillingAccountsLogsDelete_579989;
          logName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## loggingBillingAccountsLogsDelete
  ## Deletes all the log entries in a log. The log reappears if it receives new entries. Log entries written shortly before the delete operation might not be deleted.
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
  ##   logName: string (required)
  ##          : Required. The resource name of the log to delete:
  ## "projects/[PROJECT_ID]/logs/[LOG_ID]"
  ## "organizations/[ORGANIZATION_ID]/logs/[LOG_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/logs/[LOG_ID]"
  ## "folders/[FOLDER_ID]/logs/[LOG_ID]"
  ## [LOG_ID] must be URL-encoded. For example, "projects/my-project-id/logs/syslog", 
  ## "organizations/1234567890/logs/cloudresourcemanager.googleapis.com%2Factivity". For more information about log names, see LogEntry.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580020 = newJObject()
  var query_580021 = newJObject()
  add(query_580021, "upload_protocol", newJString(uploadProtocol))
  add(query_580021, "fields", newJString(fields))
  add(query_580021, "quotaUser", newJString(quotaUser))
  add(query_580021, "alt", newJString(alt))
  add(query_580021, "oauth_token", newJString(oauthToken))
  add(query_580021, "callback", newJString(callback))
  add(query_580021, "access_token", newJString(accessToken))
  add(query_580021, "uploadType", newJString(uploadType))
  add(path_580020, "logName", newJString(logName))
  add(query_580021, "key", newJString(key))
  add(query_580021, "$.xgafv", newJString(Xgafv))
  add(query_580021, "prettyPrint", newJBool(prettyPrint))
  result = call_580019.call(path_580020, query_580021, nil, nil, nil)

var loggingBillingAccountsLogsDelete* = Call_LoggingBillingAccountsLogsDelete_579989(
    name: "loggingBillingAccountsLogsDelete", meth: HttpMethod.HttpDelete,
    host: "logging.googleapis.com", route: "/v2/{logName}",
    validator: validate_LoggingBillingAccountsLogsDelete_579990, base: "/",
    url: url_LoggingBillingAccountsLogsDelete_579991, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsUpdate_580041 = ref object of OpenApiRestCall_579408
proc url_LoggingProjectsMetricsUpdate_580043(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "metricName" in path, "`metricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "metricName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingProjectsMetricsUpdate_580042(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a logs-based metric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   metricName: JString (required)
  ##             : The resource name of the metric to update:
  ## "projects/[PROJECT_ID]/metrics/[METRIC_ID]"
  ## The updated metric must be provided in the request and it's name field must be the same as [METRIC_ID] If the metric does not exist in [PROJECT_ID], then a new metric is created.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `metricName` field"
  var valid_580044 = path.getOrDefault("metricName")
  valid_580044 = validateParameter(valid_580044, JString, required = true,
                                 default = nil)
  if valid_580044 != nil:
    section.add "metricName", valid_580044
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
  var valid_580045 = query.getOrDefault("upload_protocol")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "upload_protocol", valid_580045
  var valid_580046 = query.getOrDefault("fields")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "fields", valid_580046
  var valid_580047 = query.getOrDefault("quotaUser")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "quotaUser", valid_580047
  var valid_580048 = query.getOrDefault("alt")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = newJString("json"))
  if valid_580048 != nil:
    section.add "alt", valid_580048
  var valid_580049 = query.getOrDefault("oauth_token")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "oauth_token", valid_580049
  var valid_580050 = query.getOrDefault("callback")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "callback", valid_580050
  var valid_580051 = query.getOrDefault("access_token")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "access_token", valid_580051
  var valid_580052 = query.getOrDefault("uploadType")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "uploadType", valid_580052
  var valid_580053 = query.getOrDefault("key")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "key", valid_580053
  var valid_580054 = query.getOrDefault("$.xgafv")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = newJString("1"))
  if valid_580054 != nil:
    section.add "$.xgafv", valid_580054
  var valid_580055 = query.getOrDefault("prettyPrint")
  valid_580055 = validateParameter(valid_580055, JBool, required = false,
                                 default = newJBool(true))
  if valid_580055 != nil:
    section.add "prettyPrint", valid_580055
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

proc call*(call_580057: Call_LoggingProjectsMetricsUpdate_580041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a logs-based metric.
  ## 
  let valid = call_580057.validator(path, query, header, formData, body)
  let scheme = call_580057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580057.url(scheme.get, call_580057.host, call_580057.base,
                         call_580057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580057, url, valid)

proc call*(call_580058: Call_LoggingProjectsMetricsUpdate_580041;
          metricName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## loggingProjectsMetricsUpdate
  ## Creates or updates a logs-based metric.
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
  ##   metricName: string (required)
  ##             : The resource name of the metric to update:
  ## "projects/[PROJECT_ID]/metrics/[METRIC_ID]"
  ## The updated metric must be provided in the request and it's name field must be the same as [METRIC_ID] If the metric does not exist in [PROJECT_ID], then a new metric is created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580059 = newJObject()
  var query_580060 = newJObject()
  var body_580061 = newJObject()
  add(query_580060, "upload_protocol", newJString(uploadProtocol))
  add(query_580060, "fields", newJString(fields))
  add(query_580060, "quotaUser", newJString(quotaUser))
  add(query_580060, "alt", newJString(alt))
  add(query_580060, "oauth_token", newJString(oauthToken))
  add(query_580060, "callback", newJString(callback))
  add(query_580060, "access_token", newJString(accessToken))
  add(query_580060, "uploadType", newJString(uploadType))
  add(path_580059, "metricName", newJString(metricName))
  add(query_580060, "key", newJString(key))
  add(query_580060, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580061 = body
  add(query_580060, "prettyPrint", newJBool(prettyPrint))
  result = call_580058.call(path_580059, query_580060, nil, nil, body_580061)

var loggingProjectsMetricsUpdate* = Call_LoggingProjectsMetricsUpdate_580041(
    name: "loggingProjectsMetricsUpdate", meth: HttpMethod.HttpPut,
    host: "logging.googleapis.com", route: "/v2/{metricName}",
    validator: validate_LoggingProjectsMetricsUpdate_580042, base: "/",
    url: url_LoggingProjectsMetricsUpdate_580043, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsGet_580022 = ref object of OpenApiRestCall_579408
proc url_LoggingProjectsMetricsGet_580024(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "metricName" in path, "`metricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "metricName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingProjectsMetricsGet_580023(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a logs-based metric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   metricName: JString (required)
  ##             : The resource name of the desired metric:
  ## "projects/[PROJECT_ID]/metrics/[METRIC_ID]"
  ## 
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `metricName` field"
  var valid_580025 = path.getOrDefault("metricName")
  valid_580025 = validateParameter(valid_580025, JString, required = true,
                                 default = nil)
  if valid_580025 != nil:
    section.add "metricName", valid_580025
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
  var valid_580026 = query.getOrDefault("upload_protocol")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "upload_protocol", valid_580026
  var valid_580027 = query.getOrDefault("fields")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "fields", valid_580027
  var valid_580028 = query.getOrDefault("quotaUser")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "quotaUser", valid_580028
  var valid_580029 = query.getOrDefault("alt")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = newJString("json"))
  if valid_580029 != nil:
    section.add "alt", valid_580029
  var valid_580030 = query.getOrDefault("oauth_token")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "oauth_token", valid_580030
  var valid_580031 = query.getOrDefault("callback")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "callback", valid_580031
  var valid_580032 = query.getOrDefault("access_token")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "access_token", valid_580032
  var valid_580033 = query.getOrDefault("uploadType")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "uploadType", valid_580033
  var valid_580034 = query.getOrDefault("key")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "key", valid_580034
  var valid_580035 = query.getOrDefault("$.xgafv")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("1"))
  if valid_580035 != nil:
    section.add "$.xgafv", valid_580035
  var valid_580036 = query.getOrDefault("prettyPrint")
  valid_580036 = validateParameter(valid_580036, JBool, required = false,
                                 default = newJBool(true))
  if valid_580036 != nil:
    section.add "prettyPrint", valid_580036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580037: Call_LoggingProjectsMetricsGet_580022; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a logs-based metric.
  ## 
  let valid = call_580037.validator(path, query, header, formData, body)
  let scheme = call_580037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580037.url(scheme.get, call_580037.host, call_580037.base,
                         call_580037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580037, url, valid)

proc call*(call_580038: Call_LoggingProjectsMetricsGet_580022; metricName: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## loggingProjectsMetricsGet
  ## Gets a logs-based metric.
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
  ##   metricName: string (required)
  ##             : The resource name of the desired metric:
  ## "projects/[PROJECT_ID]/metrics/[METRIC_ID]"
  ## 
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580039 = newJObject()
  var query_580040 = newJObject()
  add(query_580040, "upload_protocol", newJString(uploadProtocol))
  add(query_580040, "fields", newJString(fields))
  add(query_580040, "quotaUser", newJString(quotaUser))
  add(query_580040, "alt", newJString(alt))
  add(query_580040, "oauth_token", newJString(oauthToken))
  add(query_580040, "callback", newJString(callback))
  add(query_580040, "access_token", newJString(accessToken))
  add(query_580040, "uploadType", newJString(uploadType))
  add(path_580039, "metricName", newJString(metricName))
  add(query_580040, "key", newJString(key))
  add(query_580040, "$.xgafv", newJString(Xgafv))
  add(query_580040, "prettyPrint", newJBool(prettyPrint))
  result = call_580038.call(path_580039, query_580040, nil, nil, nil)

var loggingProjectsMetricsGet* = Call_LoggingProjectsMetricsGet_580022(
    name: "loggingProjectsMetricsGet", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{metricName}",
    validator: validate_LoggingProjectsMetricsGet_580023, base: "/",
    url: url_LoggingProjectsMetricsGet_580024, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsDelete_580062 = ref object of OpenApiRestCall_579408
proc url_LoggingProjectsMetricsDelete_580064(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "metricName" in path, "`metricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "metricName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingProjectsMetricsDelete_580063(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a logs-based metric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   metricName: JString (required)
  ##             : The resource name of the metric to delete:
  ## "projects/[PROJECT_ID]/metrics/[METRIC_ID]"
  ## 
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `metricName` field"
  var valid_580065 = path.getOrDefault("metricName")
  valid_580065 = validateParameter(valid_580065, JString, required = true,
                                 default = nil)
  if valid_580065 != nil:
    section.add "metricName", valid_580065
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
  var valid_580066 = query.getOrDefault("upload_protocol")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "upload_protocol", valid_580066
  var valid_580067 = query.getOrDefault("fields")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "fields", valid_580067
  var valid_580068 = query.getOrDefault("quotaUser")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "quotaUser", valid_580068
  var valid_580069 = query.getOrDefault("alt")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = newJString("json"))
  if valid_580069 != nil:
    section.add "alt", valid_580069
  var valid_580070 = query.getOrDefault("oauth_token")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "oauth_token", valid_580070
  var valid_580071 = query.getOrDefault("callback")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "callback", valid_580071
  var valid_580072 = query.getOrDefault("access_token")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "access_token", valid_580072
  var valid_580073 = query.getOrDefault("uploadType")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "uploadType", valid_580073
  var valid_580074 = query.getOrDefault("key")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "key", valid_580074
  var valid_580075 = query.getOrDefault("$.xgafv")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = newJString("1"))
  if valid_580075 != nil:
    section.add "$.xgafv", valid_580075
  var valid_580076 = query.getOrDefault("prettyPrint")
  valid_580076 = validateParameter(valid_580076, JBool, required = false,
                                 default = newJBool(true))
  if valid_580076 != nil:
    section.add "prettyPrint", valid_580076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580077: Call_LoggingProjectsMetricsDelete_580062; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a logs-based metric.
  ## 
  let valid = call_580077.validator(path, query, header, formData, body)
  let scheme = call_580077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580077.url(scheme.get, call_580077.host, call_580077.base,
                         call_580077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580077, url, valid)

proc call*(call_580078: Call_LoggingProjectsMetricsDelete_580062;
          metricName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## loggingProjectsMetricsDelete
  ## Deletes a logs-based metric.
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
  ##   metricName: string (required)
  ##             : The resource name of the metric to delete:
  ## "projects/[PROJECT_ID]/metrics/[METRIC_ID]"
  ## 
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580079 = newJObject()
  var query_580080 = newJObject()
  add(query_580080, "upload_protocol", newJString(uploadProtocol))
  add(query_580080, "fields", newJString(fields))
  add(query_580080, "quotaUser", newJString(quotaUser))
  add(query_580080, "alt", newJString(alt))
  add(query_580080, "oauth_token", newJString(oauthToken))
  add(query_580080, "callback", newJString(callback))
  add(query_580080, "access_token", newJString(accessToken))
  add(query_580080, "uploadType", newJString(uploadType))
  add(path_580079, "metricName", newJString(metricName))
  add(query_580080, "key", newJString(key))
  add(query_580080, "$.xgafv", newJString(Xgafv))
  add(query_580080, "prettyPrint", newJBool(prettyPrint))
  result = call_580078.call(path_580079, query_580080, nil, nil, nil)

var loggingProjectsMetricsDelete* = Call_LoggingProjectsMetricsDelete_580062(
    name: "loggingProjectsMetricsDelete", meth: HttpMethod.HttpDelete,
    host: "logging.googleapis.com", route: "/v2/{metricName}",
    validator: validate_LoggingProjectsMetricsDelete_580063, base: "/",
    url: url_LoggingProjectsMetricsDelete_580064, schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsExclusionsGet_580081 = ref object of OpenApiRestCall_579408
proc url_LoggingBillingAccountsExclusionsGet_580083(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingBillingAccountsExclusionsGet_580082(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the description of an exclusion.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of an existing exclusion:
  ## "projects/[PROJECT_ID]/exclusions/[EXCLUSION_ID]"
  ## "organizations/[ORGANIZATION_ID]/exclusions/[EXCLUSION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/exclusions/[EXCLUSION_ID]"
  ## "folders/[FOLDER_ID]/exclusions/[EXCLUSION_ID]"
  ## Example: "projects/my-project-id/exclusions/my-exclusion-id".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580084 = path.getOrDefault("name")
  valid_580084 = validateParameter(valid_580084, JString, required = true,
                                 default = nil)
  if valid_580084 != nil:
    section.add "name", valid_580084
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
  var valid_580085 = query.getOrDefault("upload_protocol")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "upload_protocol", valid_580085
  var valid_580086 = query.getOrDefault("fields")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "fields", valid_580086
  var valid_580087 = query.getOrDefault("quotaUser")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "quotaUser", valid_580087
  var valid_580088 = query.getOrDefault("alt")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = newJString("json"))
  if valid_580088 != nil:
    section.add "alt", valid_580088
  var valid_580089 = query.getOrDefault("oauth_token")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "oauth_token", valid_580089
  var valid_580090 = query.getOrDefault("callback")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "callback", valid_580090
  var valid_580091 = query.getOrDefault("access_token")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "access_token", valid_580091
  var valid_580092 = query.getOrDefault("uploadType")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "uploadType", valid_580092
  var valid_580093 = query.getOrDefault("key")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "key", valid_580093
  var valid_580094 = query.getOrDefault("$.xgafv")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = newJString("1"))
  if valid_580094 != nil:
    section.add "$.xgafv", valid_580094
  var valid_580095 = query.getOrDefault("prettyPrint")
  valid_580095 = validateParameter(valid_580095, JBool, required = false,
                                 default = newJBool(true))
  if valid_580095 != nil:
    section.add "prettyPrint", valid_580095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580096: Call_LoggingBillingAccountsExclusionsGet_580081;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the description of an exclusion.
  ## 
  let valid = call_580096.validator(path, query, header, formData, body)
  let scheme = call_580096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580096.url(scheme.get, call_580096.host, call_580096.base,
                         call_580096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580096, url, valid)

proc call*(call_580097: Call_LoggingBillingAccountsExclusionsGet_580081;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## loggingBillingAccountsExclusionsGet
  ## Gets the description of an exclusion.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of an existing exclusion:
  ## "projects/[PROJECT_ID]/exclusions/[EXCLUSION_ID]"
  ## "organizations/[ORGANIZATION_ID]/exclusions/[EXCLUSION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/exclusions/[EXCLUSION_ID]"
  ## "folders/[FOLDER_ID]/exclusions/[EXCLUSION_ID]"
  ## Example: "projects/my-project-id/exclusions/my-exclusion-id".
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580098 = newJObject()
  var query_580099 = newJObject()
  add(query_580099, "upload_protocol", newJString(uploadProtocol))
  add(query_580099, "fields", newJString(fields))
  add(query_580099, "quotaUser", newJString(quotaUser))
  add(path_580098, "name", newJString(name))
  add(query_580099, "alt", newJString(alt))
  add(query_580099, "oauth_token", newJString(oauthToken))
  add(query_580099, "callback", newJString(callback))
  add(query_580099, "access_token", newJString(accessToken))
  add(query_580099, "uploadType", newJString(uploadType))
  add(query_580099, "key", newJString(key))
  add(query_580099, "$.xgafv", newJString(Xgafv))
  add(query_580099, "prettyPrint", newJBool(prettyPrint))
  result = call_580097.call(path_580098, query_580099, nil, nil, nil)

var loggingBillingAccountsExclusionsGet* = Call_LoggingBillingAccountsExclusionsGet_580081(
    name: "loggingBillingAccountsExclusionsGet", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{name}",
    validator: validate_LoggingBillingAccountsExclusionsGet_580082, base: "/",
    url: url_LoggingBillingAccountsExclusionsGet_580083, schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsExclusionsPatch_580119 = ref object of OpenApiRestCall_579408
proc url_LoggingBillingAccountsExclusionsPatch_580121(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingBillingAccountsExclusionsPatch_580120(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Changes one or more properties of an existing exclusion.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the exclusion to update:
  ## "projects/[PROJECT_ID]/exclusions/[EXCLUSION_ID]"
  ## "organizations/[ORGANIZATION_ID]/exclusions/[EXCLUSION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/exclusions/[EXCLUSION_ID]"
  ## "folders/[FOLDER_ID]/exclusions/[EXCLUSION_ID]"
  ## Example: "projects/my-project-id/exclusions/my-exclusion-id".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580122 = path.getOrDefault("name")
  valid_580122 = validateParameter(valid_580122, JString, required = true,
                                 default = nil)
  if valid_580122 != nil:
    section.add "name", valid_580122
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
  ##   updateMask: JString
  ##             : Required. A non-empty list of fields to change in the existing exclusion. New values for the fields are taken from the corresponding fields in the LogExclusion included in this request. Fields not mentioned in update_mask are not changed and are ignored in the request.For example, to change the filter and description of an exclusion, specify an update_mask of "filter,description".
  section = newJObject()
  var valid_580123 = query.getOrDefault("upload_protocol")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "upload_protocol", valid_580123
  var valid_580124 = query.getOrDefault("fields")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "fields", valid_580124
  var valid_580125 = query.getOrDefault("quotaUser")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "quotaUser", valid_580125
  var valid_580126 = query.getOrDefault("alt")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = newJString("json"))
  if valid_580126 != nil:
    section.add "alt", valid_580126
  var valid_580127 = query.getOrDefault("oauth_token")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "oauth_token", valid_580127
  var valid_580128 = query.getOrDefault("callback")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "callback", valid_580128
  var valid_580129 = query.getOrDefault("access_token")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "access_token", valid_580129
  var valid_580130 = query.getOrDefault("uploadType")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "uploadType", valid_580130
  var valid_580131 = query.getOrDefault("key")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "key", valid_580131
  var valid_580132 = query.getOrDefault("$.xgafv")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = newJString("1"))
  if valid_580132 != nil:
    section.add "$.xgafv", valid_580132
  var valid_580133 = query.getOrDefault("prettyPrint")
  valid_580133 = validateParameter(valid_580133, JBool, required = false,
                                 default = newJBool(true))
  if valid_580133 != nil:
    section.add "prettyPrint", valid_580133
  var valid_580134 = query.getOrDefault("updateMask")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "updateMask", valid_580134
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

proc call*(call_580136: Call_LoggingBillingAccountsExclusionsPatch_580119;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Changes one or more properties of an existing exclusion.
  ## 
  let valid = call_580136.validator(path, query, header, formData, body)
  let scheme = call_580136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580136.url(scheme.get, call_580136.host, call_580136.base,
                         call_580136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580136, url, valid)

proc call*(call_580137: Call_LoggingBillingAccountsExclusionsPatch_580119;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## loggingBillingAccountsExclusionsPatch
  ## Changes one or more properties of an existing exclusion.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the exclusion to update:
  ## "projects/[PROJECT_ID]/exclusions/[EXCLUSION_ID]"
  ## "organizations/[ORGANIZATION_ID]/exclusions/[EXCLUSION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/exclusions/[EXCLUSION_ID]"
  ## "folders/[FOLDER_ID]/exclusions/[EXCLUSION_ID]"
  ## Example: "projects/my-project-id/exclusions/my-exclusion-id".
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
  ##   updateMask: string
  ##             : Required. A non-empty list of fields to change in the existing exclusion. New values for the fields are taken from the corresponding fields in the LogExclusion included in this request. Fields not mentioned in update_mask are not changed and are ignored in the request.For example, to change the filter and description of an exclusion, specify an update_mask of "filter,description".
  var path_580138 = newJObject()
  var query_580139 = newJObject()
  var body_580140 = newJObject()
  add(query_580139, "upload_protocol", newJString(uploadProtocol))
  add(query_580139, "fields", newJString(fields))
  add(query_580139, "quotaUser", newJString(quotaUser))
  add(path_580138, "name", newJString(name))
  add(query_580139, "alt", newJString(alt))
  add(query_580139, "oauth_token", newJString(oauthToken))
  add(query_580139, "callback", newJString(callback))
  add(query_580139, "access_token", newJString(accessToken))
  add(query_580139, "uploadType", newJString(uploadType))
  add(query_580139, "key", newJString(key))
  add(query_580139, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580140 = body
  add(query_580139, "prettyPrint", newJBool(prettyPrint))
  add(query_580139, "updateMask", newJString(updateMask))
  result = call_580137.call(path_580138, query_580139, nil, nil, body_580140)

var loggingBillingAccountsExclusionsPatch* = Call_LoggingBillingAccountsExclusionsPatch_580119(
    name: "loggingBillingAccountsExclusionsPatch", meth: HttpMethod.HttpPatch,
    host: "logging.googleapis.com", route: "/v2/{name}",
    validator: validate_LoggingBillingAccountsExclusionsPatch_580120, base: "/",
    url: url_LoggingBillingAccountsExclusionsPatch_580121, schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsExclusionsDelete_580100 = ref object of OpenApiRestCall_579408
proc url_LoggingBillingAccountsExclusionsDelete_580102(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingBillingAccountsExclusionsDelete_580101(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an exclusion.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of an existing exclusion to delete:
  ## "projects/[PROJECT_ID]/exclusions/[EXCLUSION_ID]"
  ## "organizations/[ORGANIZATION_ID]/exclusions/[EXCLUSION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/exclusions/[EXCLUSION_ID]"
  ## "folders/[FOLDER_ID]/exclusions/[EXCLUSION_ID]"
  ## Example: "projects/my-project-id/exclusions/my-exclusion-id".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580103 = path.getOrDefault("name")
  valid_580103 = validateParameter(valid_580103, JString, required = true,
                                 default = nil)
  if valid_580103 != nil:
    section.add "name", valid_580103
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
  var valid_580104 = query.getOrDefault("upload_protocol")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "upload_protocol", valid_580104
  var valid_580105 = query.getOrDefault("fields")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "fields", valid_580105
  var valid_580106 = query.getOrDefault("quotaUser")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "quotaUser", valid_580106
  var valid_580107 = query.getOrDefault("alt")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = newJString("json"))
  if valid_580107 != nil:
    section.add "alt", valid_580107
  var valid_580108 = query.getOrDefault("oauth_token")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "oauth_token", valid_580108
  var valid_580109 = query.getOrDefault("callback")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "callback", valid_580109
  var valid_580110 = query.getOrDefault("access_token")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "access_token", valid_580110
  var valid_580111 = query.getOrDefault("uploadType")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "uploadType", valid_580111
  var valid_580112 = query.getOrDefault("key")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "key", valid_580112
  var valid_580113 = query.getOrDefault("$.xgafv")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = newJString("1"))
  if valid_580113 != nil:
    section.add "$.xgafv", valid_580113
  var valid_580114 = query.getOrDefault("prettyPrint")
  valid_580114 = validateParameter(valid_580114, JBool, required = false,
                                 default = newJBool(true))
  if valid_580114 != nil:
    section.add "prettyPrint", valid_580114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580115: Call_LoggingBillingAccountsExclusionsDelete_580100;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an exclusion.
  ## 
  let valid = call_580115.validator(path, query, header, formData, body)
  let scheme = call_580115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580115.url(scheme.get, call_580115.host, call_580115.base,
                         call_580115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580115, url, valid)

proc call*(call_580116: Call_LoggingBillingAccountsExclusionsDelete_580100;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## loggingBillingAccountsExclusionsDelete
  ## Deletes an exclusion.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of an existing exclusion to delete:
  ## "projects/[PROJECT_ID]/exclusions/[EXCLUSION_ID]"
  ## "organizations/[ORGANIZATION_ID]/exclusions/[EXCLUSION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/exclusions/[EXCLUSION_ID]"
  ## "folders/[FOLDER_ID]/exclusions/[EXCLUSION_ID]"
  ## Example: "projects/my-project-id/exclusions/my-exclusion-id".
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580117 = newJObject()
  var query_580118 = newJObject()
  add(query_580118, "upload_protocol", newJString(uploadProtocol))
  add(query_580118, "fields", newJString(fields))
  add(query_580118, "quotaUser", newJString(quotaUser))
  add(path_580117, "name", newJString(name))
  add(query_580118, "alt", newJString(alt))
  add(query_580118, "oauth_token", newJString(oauthToken))
  add(query_580118, "callback", newJString(callback))
  add(query_580118, "access_token", newJString(accessToken))
  add(query_580118, "uploadType", newJString(uploadType))
  add(query_580118, "key", newJString(key))
  add(query_580118, "$.xgafv", newJString(Xgafv))
  add(query_580118, "prettyPrint", newJBool(prettyPrint))
  result = call_580116.call(path_580117, query_580118, nil, nil, nil)

var loggingBillingAccountsExclusionsDelete* = Call_LoggingBillingAccountsExclusionsDelete_580100(
    name: "loggingBillingAccountsExclusionsDelete", meth: HttpMethod.HttpDelete,
    host: "logging.googleapis.com", route: "/v2/{name}",
    validator: validate_LoggingBillingAccountsExclusionsDelete_580101, base: "/",
    url: url_LoggingBillingAccountsExclusionsDelete_580102,
    schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsExclusionsCreate_580162 = ref object of OpenApiRestCall_579408
proc url_LoggingBillingAccountsExclusionsCreate_580164(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/exclusions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingBillingAccountsExclusionsCreate_580163(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new exclusion in a specified parent resource. Only log entries belonging to that resource can be excluded. You can have up to 10 exclusions in a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent resource in which to create the exclusion:
  ## "projects/[PROJECT_ID]"
  ## "organizations/[ORGANIZATION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]"
  ## "folders/[FOLDER_ID]"
  ## Examples: "projects/my-logging-project", "organizations/123456789".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580165 = path.getOrDefault("parent")
  valid_580165 = validateParameter(valid_580165, JString, required = true,
                                 default = nil)
  if valid_580165 != nil:
    section.add "parent", valid_580165
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
  var valid_580166 = query.getOrDefault("upload_protocol")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "upload_protocol", valid_580166
  var valid_580167 = query.getOrDefault("fields")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "fields", valid_580167
  var valid_580168 = query.getOrDefault("quotaUser")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "quotaUser", valid_580168
  var valid_580169 = query.getOrDefault("alt")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = newJString("json"))
  if valid_580169 != nil:
    section.add "alt", valid_580169
  var valid_580170 = query.getOrDefault("oauth_token")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "oauth_token", valid_580170
  var valid_580171 = query.getOrDefault("callback")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "callback", valid_580171
  var valid_580172 = query.getOrDefault("access_token")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "access_token", valid_580172
  var valid_580173 = query.getOrDefault("uploadType")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "uploadType", valid_580173
  var valid_580174 = query.getOrDefault("key")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "key", valid_580174
  var valid_580175 = query.getOrDefault("$.xgafv")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = newJString("1"))
  if valid_580175 != nil:
    section.add "$.xgafv", valid_580175
  var valid_580176 = query.getOrDefault("prettyPrint")
  valid_580176 = validateParameter(valid_580176, JBool, required = false,
                                 default = newJBool(true))
  if valid_580176 != nil:
    section.add "prettyPrint", valid_580176
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

proc call*(call_580178: Call_LoggingBillingAccountsExclusionsCreate_580162;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new exclusion in a specified parent resource. Only log entries belonging to that resource can be excluded. You can have up to 10 exclusions in a resource.
  ## 
  let valid = call_580178.validator(path, query, header, formData, body)
  let scheme = call_580178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580178.url(scheme.get, call_580178.host, call_580178.base,
                         call_580178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580178, url, valid)

proc call*(call_580179: Call_LoggingBillingAccountsExclusionsCreate_580162;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## loggingBillingAccountsExclusionsCreate
  ## Creates a new exclusion in a specified parent resource. Only log entries belonging to that resource can be excluded. You can have up to 10 exclusions in a resource.
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
  ##   parent: string (required)
  ##         : Required. The parent resource in which to create the exclusion:
  ## "projects/[PROJECT_ID]"
  ## "organizations/[ORGANIZATION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]"
  ## "folders/[FOLDER_ID]"
  ## Examples: "projects/my-logging-project", "organizations/123456789".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580180 = newJObject()
  var query_580181 = newJObject()
  var body_580182 = newJObject()
  add(query_580181, "upload_protocol", newJString(uploadProtocol))
  add(query_580181, "fields", newJString(fields))
  add(query_580181, "quotaUser", newJString(quotaUser))
  add(query_580181, "alt", newJString(alt))
  add(query_580181, "oauth_token", newJString(oauthToken))
  add(query_580181, "callback", newJString(callback))
  add(query_580181, "access_token", newJString(accessToken))
  add(query_580181, "uploadType", newJString(uploadType))
  add(path_580180, "parent", newJString(parent))
  add(query_580181, "key", newJString(key))
  add(query_580181, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580182 = body
  add(query_580181, "prettyPrint", newJBool(prettyPrint))
  result = call_580179.call(path_580180, query_580181, nil, nil, body_580182)

var loggingBillingAccountsExclusionsCreate* = Call_LoggingBillingAccountsExclusionsCreate_580162(
    name: "loggingBillingAccountsExclusionsCreate", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2/{parent}/exclusions",
    validator: validate_LoggingBillingAccountsExclusionsCreate_580163, base: "/",
    url: url_LoggingBillingAccountsExclusionsCreate_580164,
    schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsExclusionsList_580141 = ref object of OpenApiRestCall_579408
proc url_LoggingBillingAccountsExclusionsList_580143(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/exclusions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingBillingAccountsExclusionsList_580142(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the exclusions in a parent resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent resource whose exclusions are to be listed.
  ## "projects/[PROJECT_ID]"
  ## "organizations/[ORGANIZATION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]"
  ## "folders/[FOLDER_ID]"
  ## 
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580144 = path.getOrDefault("parent")
  valid_580144 = validateParameter(valid_580144, JString, required = true,
                                 default = nil)
  if valid_580144 != nil:
    section.add "parent", valid_580144
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. If present, then retrieve the next batch of results from the preceding call to this method. pageToken must be the value of nextPageToken from the previous response. The values of other method parameters should be identical to those in the previous call.
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
  ##   pageSize: JInt
  ##           : Optional. The maximum number of results to return from this request. Non-positive values are ignored. The presence of nextPageToken in the response indicates that more results might be available.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580145 = query.getOrDefault("upload_protocol")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "upload_protocol", valid_580145
  var valid_580146 = query.getOrDefault("fields")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "fields", valid_580146
  var valid_580147 = query.getOrDefault("pageToken")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "pageToken", valid_580147
  var valid_580148 = query.getOrDefault("quotaUser")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "quotaUser", valid_580148
  var valid_580149 = query.getOrDefault("alt")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = newJString("json"))
  if valid_580149 != nil:
    section.add "alt", valid_580149
  var valid_580150 = query.getOrDefault("oauth_token")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "oauth_token", valid_580150
  var valid_580151 = query.getOrDefault("callback")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "callback", valid_580151
  var valid_580152 = query.getOrDefault("access_token")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "access_token", valid_580152
  var valid_580153 = query.getOrDefault("uploadType")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "uploadType", valid_580153
  var valid_580154 = query.getOrDefault("key")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "key", valid_580154
  var valid_580155 = query.getOrDefault("$.xgafv")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = newJString("1"))
  if valid_580155 != nil:
    section.add "$.xgafv", valid_580155
  var valid_580156 = query.getOrDefault("pageSize")
  valid_580156 = validateParameter(valid_580156, JInt, required = false, default = nil)
  if valid_580156 != nil:
    section.add "pageSize", valid_580156
  var valid_580157 = query.getOrDefault("prettyPrint")
  valid_580157 = validateParameter(valid_580157, JBool, required = false,
                                 default = newJBool(true))
  if valid_580157 != nil:
    section.add "prettyPrint", valid_580157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580158: Call_LoggingBillingAccountsExclusionsList_580141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the exclusions in a parent resource.
  ## 
  let valid = call_580158.validator(path, query, header, formData, body)
  let scheme = call_580158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580158.url(scheme.get, call_580158.host, call_580158.base,
                         call_580158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580158, url, valid)

proc call*(call_580159: Call_LoggingBillingAccountsExclusionsList_580141;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## loggingBillingAccountsExclusionsList
  ## Lists all the exclusions in a parent resource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. If present, then retrieve the next batch of results from the preceding call to this method. pageToken must be the value of nextPageToken from the previous response. The values of other method parameters should be identical to those in the previous call.
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
  ##   parent: string (required)
  ##         : Required. The parent resource whose exclusions are to be listed.
  ## "projects/[PROJECT_ID]"
  ## "organizations/[ORGANIZATION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]"
  ## "folders/[FOLDER_ID]"
  ## 
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of results to return from this request. Non-positive values are ignored. The presence of nextPageToken in the response indicates that more results might be available.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580160 = newJObject()
  var query_580161 = newJObject()
  add(query_580161, "upload_protocol", newJString(uploadProtocol))
  add(query_580161, "fields", newJString(fields))
  add(query_580161, "pageToken", newJString(pageToken))
  add(query_580161, "quotaUser", newJString(quotaUser))
  add(query_580161, "alt", newJString(alt))
  add(query_580161, "oauth_token", newJString(oauthToken))
  add(query_580161, "callback", newJString(callback))
  add(query_580161, "access_token", newJString(accessToken))
  add(query_580161, "uploadType", newJString(uploadType))
  add(path_580160, "parent", newJString(parent))
  add(query_580161, "key", newJString(key))
  add(query_580161, "$.xgafv", newJString(Xgafv))
  add(query_580161, "pageSize", newJInt(pageSize))
  add(query_580161, "prettyPrint", newJBool(prettyPrint))
  result = call_580159.call(path_580160, query_580161, nil, nil, nil)

var loggingBillingAccountsExclusionsList* = Call_LoggingBillingAccountsExclusionsList_580141(
    name: "loggingBillingAccountsExclusionsList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{parent}/exclusions",
    validator: validate_LoggingBillingAccountsExclusionsList_580142, base: "/",
    url: url_LoggingBillingAccountsExclusionsList_580143, schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsLogsList_580183 = ref object of OpenApiRestCall_579408
proc url_LoggingBillingAccountsLogsList_580185(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/logs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingBillingAccountsLogsList_580184(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the logs in projects, organizations, folders, or billing accounts. Only logs that have entries are listed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The resource name that owns the logs:
  ## "projects/[PROJECT_ID]"
  ## "organizations/[ORGANIZATION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]"
  ## "folders/[FOLDER_ID]"
  ## 
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580186 = path.getOrDefault("parent")
  valid_580186 = validateParameter(valid_580186, JString, required = true,
                                 default = nil)
  if valid_580186 != nil:
    section.add "parent", valid_580186
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. If present, then retrieve the next batch of results from the preceding call to this method. pageToken must be the value of nextPageToken from the previous response. The values of other method parameters should be identical to those in the previous call.
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
  ##   pageSize: JInt
  ##           : Optional. The maximum number of results to return from this request. Non-positive values are ignored. The presence of nextPageToken in the response indicates that more results might be available.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580187 = query.getOrDefault("upload_protocol")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "upload_protocol", valid_580187
  var valid_580188 = query.getOrDefault("fields")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "fields", valid_580188
  var valid_580189 = query.getOrDefault("pageToken")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "pageToken", valid_580189
  var valid_580190 = query.getOrDefault("quotaUser")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "quotaUser", valid_580190
  var valid_580191 = query.getOrDefault("alt")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = newJString("json"))
  if valid_580191 != nil:
    section.add "alt", valid_580191
  var valid_580192 = query.getOrDefault("oauth_token")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "oauth_token", valid_580192
  var valid_580193 = query.getOrDefault("callback")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "callback", valid_580193
  var valid_580194 = query.getOrDefault("access_token")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "access_token", valid_580194
  var valid_580195 = query.getOrDefault("uploadType")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "uploadType", valid_580195
  var valid_580196 = query.getOrDefault("key")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "key", valid_580196
  var valid_580197 = query.getOrDefault("$.xgafv")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = newJString("1"))
  if valid_580197 != nil:
    section.add "$.xgafv", valid_580197
  var valid_580198 = query.getOrDefault("pageSize")
  valid_580198 = validateParameter(valid_580198, JInt, required = false, default = nil)
  if valid_580198 != nil:
    section.add "pageSize", valid_580198
  var valid_580199 = query.getOrDefault("prettyPrint")
  valid_580199 = validateParameter(valid_580199, JBool, required = false,
                                 default = newJBool(true))
  if valid_580199 != nil:
    section.add "prettyPrint", valid_580199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580200: Call_LoggingBillingAccountsLogsList_580183; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the logs in projects, organizations, folders, or billing accounts. Only logs that have entries are listed.
  ## 
  let valid = call_580200.validator(path, query, header, formData, body)
  let scheme = call_580200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580200.url(scheme.get, call_580200.host, call_580200.base,
                         call_580200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580200, url, valid)

proc call*(call_580201: Call_LoggingBillingAccountsLogsList_580183; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## loggingBillingAccountsLogsList
  ## Lists the logs in projects, organizations, folders, or billing accounts. Only logs that have entries are listed.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. If present, then retrieve the next batch of results from the preceding call to this method. pageToken must be the value of nextPageToken from the previous response. The values of other method parameters should be identical to those in the previous call.
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
  ##   parent: string (required)
  ##         : Required. The resource name that owns the logs:
  ## "projects/[PROJECT_ID]"
  ## "organizations/[ORGANIZATION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]"
  ## "folders/[FOLDER_ID]"
  ## 
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of results to return from this request. Non-positive values are ignored. The presence of nextPageToken in the response indicates that more results might be available.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580202 = newJObject()
  var query_580203 = newJObject()
  add(query_580203, "upload_protocol", newJString(uploadProtocol))
  add(query_580203, "fields", newJString(fields))
  add(query_580203, "pageToken", newJString(pageToken))
  add(query_580203, "quotaUser", newJString(quotaUser))
  add(query_580203, "alt", newJString(alt))
  add(query_580203, "oauth_token", newJString(oauthToken))
  add(query_580203, "callback", newJString(callback))
  add(query_580203, "access_token", newJString(accessToken))
  add(query_580203, "uploadType", newJString(uploadType))
  add(path_580202, "parent", newJString(parent))
  add(query_580203, "key", newJString(key))
  add(query_580203, "$.xgafv", newJString(Xgafv))
  add(query_580203, "pageSize", newJInt(pageSize))
  add(query_580203, "prettyPrint", newJBool(prettyPrint))
  result = call_580201.call(path_580202, query_580203, nil, nil, nil)

var loggingBillingAccountsLogsList* = Call_LoggingBillingAccountsLogsList_580183(
    name: "loggingBillingAccountsLogsList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{parent}/logs",
    validator: validate_LoggingBillingAccountsLogsList_580184, base: "/",
    url: url_LoggingBillingAccountsLogsList_580185, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsCreate_580225 = ref object of OpenApiRestCall_579408
proc url_LoggingProjectsMetricsCreate_580227(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingProjectsMetricsCreate_580226(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a logs-based metric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The resource name of the project in which to create the metric:
  ## "projects/[PROJECT_ID]"
  ## The new metric must be provided in the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580228 = path.getOrDefault("parent")
  valid_580228 = validateParameter(valid_580228, JString, required = true,
                                 default = nil)
  if valid_580228 != nil:
    section.add "parent", valid_580228
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
  var valid_580229 = query.getOrDefault("upload_protocol")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "upload_protocol", valid_580229
  var valid_580230 = query.getOrDefault("fields")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "fields", valid_580230
  var valid_580231 = query.getOrDefault("quotaUser")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "quotaUser", valid_580231
  var valid_580232 = query.getOrDefault("alt")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = newJString("json"))
  if valid_580232 != nil:
    section.add "alt", valid_580232
  var valid_580233 = query.getOrDefault("oauth_token")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "oauth_token", valid_580233
  var valid_580234 = query.getOrDefault("callback")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "callback", valid_580234
  var valid_580235 = query.getOrDefault("access_token")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "access_token", valid_580235
  var valid_580236 = query.getOrDefault("uploadType")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "uploadType", valid_580236
  var valid_580237 = query.getOrDefault("key")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "key", valid_580237
  var valid_580238 = query.getOrDefault("$.xgafv")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = newJString("1"))
  if valid_580238 != nil:
    section.add "$.xgafv", valid_580238
  var valid_580239 = query.getOrDefault("prettyPrint")
  valid_580239 = validateParameter(valid_580239, JBool, required = false,
                                 default = newJBool(true))
  if valid_580239 != nil:
    section.add "prettyPrint", valid_580239
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

proc call*(call_580241: Call_LoggingProjectsMetricsCreate_580225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a logs-based metric.
  ## 
  let valid = call_580241.validator(path, query, header, formData, body)
  let scheme = call_580241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580241.url(scheme.get, call_580241.host, call_580241.base,
                         call_580241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580241, url, valid)

proc call*(call_580242: Call_LoggingProjectsMetricsCreate_580225; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## loggingProjectsMetricsCreate
  ## Creates a logs-based metric.
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
  ##   parent: string (required)
  ##         : The resource name of the project in which to create the metric:
  ## "projects/[PROJECT_ID]"
  ## The new metric must be provided in the request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580243 = newJObject()
  var query_580244 = newJObject()
  var body_580245 = newJObject()
  add(query_580244, "upload_protocol", newJString(uploadProtocol))
  add(query_580244, "fields", newJString(fields))
  add(query_580244, "quotaUser", newJString(quotaUser))
  add(query_580244, "alt", newJString(alt))
  add(query_580244, "oauth_token", newJString(oauthToken))
  add(query_580244, "callback", newJString(callback))
  add(query_580244, "access_token", newJString(accessToken))
  add(query_580244, "uploadType", newJString(uploadType))
  add(path_580243, "parent", newJString(parent))
  add(query_580244, "key", newJString(key))
  add(query_580244, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580245 = body
  add(query_580244, "prettyPrint", newJBool(prettyPrint))
  result = call_580242.call(path_580243, query_580244, nil, nil, body_580245)

var loggingProjectsMetricsCreate* = Call_LoggingProjectsMetricsCreate_580225(
    name: "loggingProjectsMetricsCreate", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2/{parent}/metrics",
    validator: validate_LoggingProjectsMetricsCreate_580226, base: "/",
    url: url_LoggingProjectsMetricsCreate_580227, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsList_580204 = ref object of OpenApiRestCall_579408
proc url_LoggingProjectsMetricsList_580206(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingProjectsMetricsList_580205(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists logs-based metrics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the project containing the metrics:
  ## "projects/[PROJECT_ID]"
  ## 
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580207 = path.getOrDefault("parent")
  valid_580207 = validateParameter(valid_580207, JString, required = true,
                                 default = nil)
  if valid_580207 != nil:
    section.add "parent", valid_580207
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. If present, then retrieve the next batch of results from the preceding call to this method. pageToken must be the value of nextPageToken from the previous response. The values of other method parameters should be identical to those in the previous call.
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
  ##   pageSize: JInt
  ##           : Optional. The maximum number of results to return from this request. Non-positive values are ignored. The presence of nextPageToken in the response indicates that more results might be available.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580208 = query.getOrDefault("upload_protocol")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "upload_protocol", valid_580208
  var valid_580209 = query.getOrDefault("fields")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "fields", valid_580209
  var valid_580210 = query.getOrDefault("pageToken")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "pageToken", valid_580210
  var valid_580211 = query.getOrDefault("quotaUser")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "quotaUser", valid_580211
  var valid_580212 = query.getOrDefault("alt")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = newJString("json"))
  if valid_580212 != nil:
    section.add "alt", valid_580212
  var valid_580213 = query.getOrDefault("oauth_token")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "oauth_token", valid_580213
  var valid_580214 = query.getOrDefault("callback")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "callback", valid_580214
  var valid_580215 = query.getOrDefault("access_token")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "access_token", valid_580215
  var valid_580216 = query.getOrDefault("uploadType")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "uploadType", valid_580216
  var valid_580217 = query.getOrDefault("key")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "key", valid_580217
  var valid_580218 = query.getOrDefault("$.xgafv")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = newJString("1"))
  if valid_580218 != nil:
    section.add "$.xgafv", valid_580218
  var valid_580219 = query.getOrDefault("pageSize")
  valid_580219 = validateParameter(valid_580219, JInt, required = false, default = nil)
  if valid_580219 != nil:
    section.add "pageSize", valid_580219
  var valid_580220 = query.getOrDefault("prettyPrint")
  valid_580220 = validateParameter(valid_580220, JBool, required = false,
                                 default = newJBool(true))
  if valid_580220 != nil:
    section.add "prettyPrint", valid_580220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580221: Call_LoggingProjectsMetricsList_580204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists logs-based metrics.
  ## 
  let valid = call_580221.validator(path, query, header, formData, body)
  let scheme = call_580221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580221.url(scheme.get, call_580221.host, call_580221.base,
                         call_580221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580221, url, valid)

proc call*(call_580222: Call_LoggingProjectsMetricsList_580204; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## loggingProjectsMetricsList
  ## Lists logs-based metrics.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. If present, then retrieve the next batch of results from the preceding call to this method. pageToken must be the value of nextPageToken from the previous response. The values of other method parameters should be identical to those in the previous call.
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
  ##   parent: string (required)
  ##         : Required. The name of the project containing the metrics:
  ## "projects/[PROJECT_ID]"
  ## 
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of results to return from this request. Non-positive values are ignored. The presence of nextPageToken in the response indicates that more results might be available.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580223 = newJObject()
  var query_580224 = newJObject()
  add(query_580224, "upload_protocol", newJString(uploadProtocol))
  add(query_580224, "fields", newJString(fields))
  add(query_580224, "pageToken", newJString(pageToken))
  add(query_580224, "quotaUser", newJString(quotaUser))
  add(query_580224, "alt", newJString(alt))
  add(query_580224, "oauth_token", newJString(oauthToken))
  add(query_580224, "callback", newJString(callback))
  add(query_580224, "access_token", newJString(accessToken))
  add(query_580224, "uploadType", newJString(uploadType))
  add(path_580223, "parent", newJString(parent))
  add(query_580224, "key", newJString(key))
  add(query_580224, "$.xgafv", newJString(Xgafv))
  add(query_580224, "pageSize", newJInt(pageSize))
  add(query_580224, "prettyPrint", newJBool(prettyPrint))
  result = call_580222.call(path_580223, query_580224, nil, nil, nil)

var loggingProjectsMetricsList* = Call_LoggingProjectsMetricsList_580204(
    name: "loggingProjectsMetricsList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{parent}/metrics",
    validator: validate_LoggingProjectsMetricsList_580205, base: "/",
    url: url_LoggingProjectsMetricsList_580206, schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsSinksCreate_580267 = ref object of OpenApiRestCall_579408
proc url_LoggingBillingAccountsSinksCreate_580269(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/sinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingBillingAccountsSinksCreate_580268(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a sink that exports specified log entries to a destination. The export of newly-ingested log entries begins immediately, unless the sink's writer_identity is not permitted to write to the destination. A sink can export log entries only from the resource owning the sink.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The resource in which to create the sink:
  ## "projects/[PROJECT_ID]"
  ## "organizations/[ORGANIZATION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]"
  ## "folders/[FOLDER_ID]"
  ## Examples: "projects/my-logging-project", "organizations/123456789".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580270 = path.getOrDefault("parent")
  valid_580270 = validateParameter(valid_580270, JString, required = true,
                                 default = nil)
  if valid_580270 != nil:
    section.add "parent", valid_580270
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
  ##   uniqueWriterIdentity: JBool
  ##                       : Optional. Determines the kind of IAM identity returned as writer_identity in the new sink. If this value is omitted or set to false, and if the sink's parent is a project, then the value returned as writer_identity is the same group or service account used by Logging before the addition of writer identities to this API. The sink's destination must be in the same project as the sink itself.If this field is set to true, or if the sink is owned by a non-project resource such as an organization, then the value of writer_identity will be a unique service account used only for exports from the new sink. For more information, see writer_identity in LogSink.
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
  var valid_580271 = query.getOrDefault("upload_protocol")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "upload_protocol", valid_580271
  var valid_580272 = query.getOrDefault("fields")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "fields", valid_580272
  var valid_580273 = query.getOrDefault("quotaUser")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "quotaUser", valid_580273
  var valid_580274 = query.getOrDefault("alt")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = newJString("json"))
  if valid_580274 != nil:
    section.add "alt", valid_580274
  var valid_580275 = query.getOrDefault("uniqueWriterIdentity")
  valid_580275 = validateParameter(valid_580275, JBool, required = false, default = nil)
  if valid_580275 != nil:
    section.add "uniqueWriterIdentity", valid_580275
  var valid_580276 = query.getOrDefault("oauth_token")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "oauth_token", valid_580276
  var valid_580277 = query.getOrDefault("callback")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "callback", valid_580277
  var valid_580278 = query.getOrDefault("access_token")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "access_token", valid_580278
  var valid_580279 = query.getOrDefault("uploadType")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "uploadType", valid_580279
  var valid_580280 = query.getOrDefault("key")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "key", valid_580280
  var valid_580281 = query.getOrDefault("$.xgafv")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = newJString("1"))
  if valid_580281 != nil:
    section.add "$.xgafv", valid_580281
  var valid_580282 = query.getOrDefault("prettyPrint")
  valid_580282 = validateParameter(valid_580282, JBool, required = false,
                                 default = newJBool(true))
  if valid_580282 != nil:
    section.add "prettyPrint", valid_580282
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

proc call*(call_580284: Call_LoggingBillingAccountsSinksCreate_580267;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a sink that exports specified log entries to a destination. The export of newly-ingested log entries begins immediately, unless the sink's writer_identity is not permitted to write to the destination. A sink can export log entries only from the resource owning the sink.
  ## 
  let valid = call_580284.validator(path, query, header, formData, body)
  let scheme = call_580284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580284.url(scheme.get, call_580284.host, call_580284.base,
                         call_580284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580284, url, valid)

proc call*(call_580285: Call_LoggingBillingAccountsSinksCreate_580267;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          uniqueWriterIdentity: bool = false; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## loggingBillingAccountsSinksCreate
  ## Creates a sink that exports specified log entries to a destination. The export of newly-ingested log entries begins immediately, unless the sink's writer_identity is not permitted to write to the destination. A sink can export log entries only from the resource owning the sink.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   uniqueWriterIdentity: bool
  ##                       : Optional. Determines the kind of IAM identity returned as writer_identity in the new sink. If this value is omitted or set to false, and if the sink's parent is a project, then the value returned as writer_identity is the same group or service account used by Logging before the addition of writer identities to this API. The sink's destination must be in the same project as the sink itself.If this field is set to true, or if the sink is owned by a non-project resource such as an organization, then the value of writer_identity will be a unique service account used only for exports from the new sink. For more information, see writer_identity in LogSink.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The resource in which to create the sink:
  ## "projects/[PROJECT_ID]"
  ## "organizations/[ORGANIZATION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]"
  ## "folders/[FOLDER_ID]"
  ## Examples: "projects/my-logging-project", "organizations/123456789".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580286 = newJObject()
  var query_580287 = newJObject()
  var body_580288 = newJObject()
  add(query_580287, "upload_protocol", newJString(uploadProtocol))
  add(query_580287, "fields", newJString(fields))
  add(query_580287, "quotaUser", newJString(quotaUser))
  add(query_580287, "alt", newJString(alt))
  add(query_580287, "uniqueWriterIdentity", newJBool(uniqueWriterIdentity))
  add(query_580287, "oauth_token", newJString(oauthToken))
  add(query_580287, "callback", newJString(callback))
  add(query_580287, "access_token", newJString(accessToken))
  add(query_580287, "uploadType", newJString(uploadType))
  add(path_580286, "parent", newJString(parent))
  add(query_580287, "key", newJString(key))
  add(query_580287, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580288 = body
  add(query_580287, "prettyPrint", newJBool(prettyPrint))
  result = call_580285.call(path_580286, query_580287, nil, nil, body_580288)

var loggingBillingAccountsSinksCreate* = Call_LoggingBillingAccountsSinksCreate_580267(
    name: "loggingBillingAccountsSinksCreate", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2/{parent}/sinks",
    validator: validate_LoggingBillingAccountsSinksCreate_580268, base: "/",
    url: url_LoggingBillingAccountsSinksCreate_580269, schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsSinksList_580246 = ref object of OpenApiRestCall_579408
proc url_LoggingBillingAccountsSinksList_580248(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/sinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingBillingAccountsSinksList_580247(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists sinks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent resource whose sinks are to be listed:
  ## "projects/[PROJECT_ID]"
  ## "organizations/[ORGANIZATION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]"
  ## "folders/[FOLDER_ID]"
  ## 
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580249 = path.getOrDefault("parent")
  valid_580249 = validateParameter(valid_580249, JString, required = true,
                                 default = nil)
  if valid_580249 != nil:
    section.add "parent", valid_580249
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. If present, then retrieve the next batch of results from the preceding call to this method. pageToken must be the value of nextPageToken from the previous response. The values of other method parameters should be identical to those in the previous call.
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
  ##   pageSize: JInt
  ##           : Optional. The maximum number of results to return from this request. Non-positive values are ignored. The presence of nextPageToken in the response indicates that more results might be available.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580250 = query.getOrDefault("upload_protocol")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "upload_protocol", valid_580250
  var valid_580251 = query.getOrDefault("fields")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "fields", valid_580251
  var valid_580252 = query.getOrDefault("pageToken")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "pageToken", valid_580252
  var valid_580253 = query.getOrDefault("quotaUser")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "quotaUser", valid_580253
  var valid_580254 = query.getOrDefault("alt")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = newJString("json"))
  if valid_580254 != nil:
    section.add "alt", valid_580254
  var valid_580255 = query.getOrDefault("oauth_token")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "oauth_token", valid_580255
  var valid_580256 = query.getOrDefault("callback")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "callback", valid_580256
  var valid_580257 = query.getOrDefault("access_token")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "access_token", valid_580257
  var valid_580258 = query.getOrDefault("uploadType")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "uploadType", valid_580258
  var valid_580259 = query.getOrDefault("key")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "key", valid_580259
  var valid_580260 = query.getOrDefault("$.xgafv")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = newJString("1"))
  if valid_580260 != nil:
    section.add "$.xgafv", valid_580260
  var valid_580261 = query.getOrDefault("pageSize")
  valid_580261 = validateParameter(valid_580261, JInt, required = false, default = nil)
  if valid_580261 != nil:
    section.add "pageSize", valid_580261
  var valid_580262 = query.getOrDefault("prettyPrint")
  valid_580262 = validateParameter(valid_580262, JBool, required = false,
                                 default = newJBool(true))
  if valid_580262 != nil:
    section.add "prettyPrint", valid_580262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580263: Call_LoggingBillingAccountsSinksList_580246;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists sinks.
  ## 
  let valid = call_580263.validator(path, query, header, formData, body)
  let scheme = call_580263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580263.url(scheme.get, call_580263.host, call_580263.base,
                         call_580263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580263, url, valid)

proc call*(call_580264: Call_LoggingBillingAccountsSinksList_580246;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## loggingBillingAccountsSinksList
  ## Lists sinks.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. If present, then retrieve the next batch of results from the preceding call to this method. pageToken must be the value of nextPageToken from the previous response. The values of other method parameters should be identical to those in the previous call.
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
  ##   parent: string (required)
  ##         : Required. The parent resource whose sinks are to be listed:
  ## "projects/[PROJECT_ID]"
  ## "organizations/[ORGANIZATION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]"
  ## "folders/[FOLDER_ID]"
  ## 
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of results to return from this request. Non-positive values are ignored. The presence of nextPageToken in the response indicates that more results might be available.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580265 = newJObject()
  var query_580266 = newJObject()
  add(query_580266, "upload_protocol", newJString(uploadProtocol))
  add(query_580266, "fields", newJString(fields))
  add(query_580266, "pageToken", newJString(pageToken))
  add(query_580266, "quotaUser", newJString(quotaUser))
  add(query_580266, "alt", newJString(alt))
  add(query_580266, "oauth_token", newJString(oauthToken))
  add(query_580266, "callback", newJString(callback))
  add(query_580266, "access_token", newJString(accessToken))
  add(query_580266, "uploadType", newJString(uploadType))
  add(path_580265, "parent", newJString(parent))
  add(query_580266, "key", newJString(key))
  add(query_580266, "$.xgafv", newJString(Xgafv))
  add(query_580266, "pageSize", newJInt(pageSize))
  add(query_580266, "prettyPrint", newJBool(prettyPrint))
  result = call_580264.call(path_580265, query_580266, nil, nil, nil)

var loggingBillingAccountsSinksList* = Call_LoggingBillingAccountsSinksList_580246(
    name: "loggingBillingAccountsSinksList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{parent}/sinks",
    validator: validate_LoggingBillingAccountsSinksList_580247, base: "/",
    url: url_LoggingBillingAccountsSinksList_580248, schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsSinksUpdate_580308 = ref object of OpenApiRestCall_579408
proc url_LoggingBillingAccountsSinksUpdate_580310(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "sinkName" in path, "`sinkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "sinkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingBillingAccountsSinksUpdate_580309(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a sink. This method replaces the following fields in the existing sink with values from the new sink: destination, and filter.The updated sink might also have a new writer_identity; see the unique_writer_identity field.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sinkName: JString (required)
  ##           : Required. The full resource name of the sink to update, including the parent resource and the sink identifier:
  ## "projects/[PROJECT_ID]/sinks/[SINK_ID]"
  ## "organizations/[ORGANIZATION_ID]/sinks/[SINK_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/sinks/[SINK_ID]"
  ## "folders/[FOLDER_ID]/sinks/[SINK_ID]"
  ## Example: "projects/my-project-id/sinks/my-sink-id".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sinkName` field"
  var valid_580311 = path.getOrDefault("sinkName")
  valid_580311 = validateParameter(valid_580311, JString, required = true,
                                 default = nil)
  if valid_580311 != nil:
    section.add "sinkName", valid_580311
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
  ##   uniqueWriterIdentity: JBool
  ##                       : Optional. See sinks.create for a description of this field. When updating a sink, the effect of this field on the value of writer_identity in the updated sink depends on both the old and new values of this field:
  ## If the old and new values of this field are both false or both true, then there is no change to the sink's writer_identity.
  ## If the old value is false and the new value is true, then writer_identity is changed to a unique service account.
  ## It is an error if the old value is true and the new value is set to false or defaulted to false.
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
  ##   updateMask: JString
  ##             : Optional. Field mask that specifies the fields in sink that need an update. A sink field will be overwritten if, and only if, it is in the update mask. name and output only fields cannot be updated.An empty updateMask is temporarily treated as using the following mask for backwards compatibility purposes:  destination,filter,includeChildren At some point in the future, behavior will be removed and specifying an empty updateMask will be an error.For a detailed FieldMask definition, see 
  ## https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#google.protobuf.FieldMaskExample: updateMask=filter.
  section = newJObject()
  var valid_580312 = query.getOrDefault("upload_protocol")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "upload_protocol", valid_580312
  var valid_580313 = query.getOrDefault("fields")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "fields", valid_580313
  var valid_580314 = query.getOrDefault("quotaUser")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "quotaUser", valid_580314
  var valid_580315 = query.getOrDefault("alt")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = newJString("json"))
  if valid_580315 != nil:
    section.add "alt", valid_580315
  var valid_580316 = query.getOrDefault("uniqueWriterIdentity")
  valid_580316 = validateParameter(valid_580316, JBool, required = false, default = nil)
  if valid_580316 != nil:
    section.add "uniqueWriterIdentity", valid_580316
  var valid_580317 = query.getOrDefault("oauth_token")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "oauth_token", valid_580317
  var valid_580318 = query.getOrDefault("callback")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "callback", valid_580318
  var valid_580319 = query.getOrDefault("access_token")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "access_token", valid_580319
  var valid_580320 = query.getOrDefault("uploadType")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "uploadType", valid_580320
  var valid_580321 = query.getOrDefault("key")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "key", valid_580321
  var valid_580322 = query.getOrDefault("$.xgafv")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = newJString("1"))
  if valid_580322 != nil:
    section.add "$.xgafv", valid_580322
  var valid_580323 = query.getOrDefault("prettyPrint")
  valid_580323 = validateParameter(valid_580323, JBool, required = false,
                                 default = newJBool(true))
  if valid_580323 != nil:
    section.add "prettyPrint", valid_580323
  var valid_580324 = query.getOrDefault("updateMask")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "updateMask", valid_580324
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

proc call*(call_580326: Call_LoggingBillingAccountsSinksUpdate_580308;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a sink. This method replaces the following fields in the existing sink with values from the new sink: destination, and filter.The updated sink might also have a new writer_identity; see the unique_writer_identity field.
  ## 
  let valid = call_580326.validator(path, query, header, formData, body)
  let scheme = call_580326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580326.url(scheme.get, call_580326.host, call_580326.base,
                         call_580326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580326, url, valid)

proc call*(call_580327: Call_LoggingBillingAccountsSinksUpdate_580308;
          sinkName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          uniqueWriterIdentity: bool = false; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## loggingBillingAccountsSinksUpdate
  ## Updates a sink. This method replaces the following fields in the existing sink with values from the new sink: destination, and filter.The updated sink might also have a new writer_identity; see the unique_writer_identity field.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   sinkName: string (required)
  ##           : Required. The full resource name of the sink to update, including the parent resource and the sink identifier:
  ## "projects/[PROJECT_ID]/sinks/[SINK_ID]"
  ## "organizations/[ORGANIZATION_ID]/sinks/[SINK_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/sinks/[SINK_ID]"
  ## "folders/[FOLDER_ID]/sinks/[SINK_ID]"
  ## Example: "projects/my-project-id/sinks/my-sink-id".
  ##   alt: string
  ##      : Data format for response.
  ##   uniqueWriterIdentity: bool
  ##                       : Optional. See sinks.create for a description of this field. When updating a sink, the effect of this field on the value of writer_identity in the updated sink depends on both the old and new values of this field:
  ## If the old and new values of this field are both false or both true, then there is no change to the sink's writer_identity.
  ## If the old value is false and the new value is true, then writer_identity is changed to a unique service account.
  ## It is an error if the old value is true and the new value is set to false or defaulted to false.
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
  ##   updateMask: string
  ##             : Optional. Field mask that specifies the fields in sink that need an update. A sink field will be overwritten if, and only if, it is in the update mask. name and output only fields cannot be updated.An empty updateMask is temporarily treated as using the following mask for backwards compatibility purposes:  destination,filter,includeChildren At some point in the future, behavior will be removed and specifying an empty updateMask will be an error.For a detailed FieldMask definition, see 
  ## https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#google.protobuf.FieldMaskExample: updateMask=filter.
  var path_580328 = newJObject()
  var query_580329 = newJObject()
  var body_580330 = newJObject()
  add(query_580329, "upload_protocol", newJString(uploadProtocol))
  add(query_580329, "fields", newJString(fields))
  add(query_580329, "quotaUser", newJString(quotaUser))
  add(path_580328, "sinkName", newJString(sinkName))
  add(query_580329, "alt", newJString(alt))
  add(query_580329, "uniqueWriterIdentity", newJBool(uniqueWriterIdentity))
  add(query_580329, "oauth_token", newJString(oauthToken))
  add(query_580329, "callback", newJString(callback))
  add(query_580329, "access_token", newJString(accessToken))
  add(query_580329, "uploadType", newJString(uploadType))
  add(query_580329, "key", newJString(key))
  add(query_580329, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580330 = body
  add(query_580329, "prettyPrint", newJBool(prettyPrint))
  add(query_580329, "updateMask", newJString(updateMask))
  result = call_580327.call(path_580328, query_580329, nil, nil, body_580330)

var loggingBillingAccountsSinksUpdate* = Call_LoggingBillingAccountsSinksUpdate_580308(
    name: "loggingBillingAccountsSinksUpdate", meth: HttpMethod.HttpPut,
    host: "logging.googleapis.com", route: "/v2/{sinkName}",
    validator: validate_LoggingBillingAccountsSinksUpdate_580309, base: "/",
    url: url_LoggingBillingAccountsSinksUpdate_580310, schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsSinksGet_580289 = ref object of OpenApiRestCall_579408
proc url_LoggingBillingAccountsSinksGet_580291(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "sinkName" in path, "`sinkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "sinkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingBillingAccountsSinksGet_580290(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a sink.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sinkName: JString (required)
  ##           : Required. The resource name of the sink:
  ## "projects/[PROJECT_ID]/sinks/[SINK_ID]"
  ## "organizations/[ORGANIZATION_ID]/sinks/[SINK_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/sinks/[SINK_ID]"
  ## "folders/[FOLDER_ID]/sinks/[SINK_ID]"
  ## Example: "projects/my-project-id/sinks/my-sink-id".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sinkName` field"
  var valid_580292 = path.getOrDefault("sinkName")
  valid_580292 = validateParameter(valid_580292, JString, required = true,
                                 default = nil)
  if valid_580292 != nil:
    section.add "sinkName", valid_580292
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
  var valid_580293 = query.getOrDefault("upload_protocol")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "upload_protocol", valid_580293
  var valid_580294 = query.getOrDefault("fields")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "fields", valid_580294
  var valid_580295 = query.getOrDefault("quotaUser")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "quotaUser", valid_580295
  var valid_580296 = query.getOrDefault("alt")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = newJString("json"))
  if valid_580296 != nil:
    section.add "alt", valid_580296
  var valid_580297 = query.getOrDefault("oauth_token")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "oauth_token", valid_580297
  var valid_580298 = query.getOrDefault("callback")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "callback", valid_580298
  var valid_580299 = query.getOrDefault("access_token")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "access_token", valid_580299
  var valid_580300 = query.getOrDefault("uploadType")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "uploadType", valid_580300
  var valid_580301 = query.getOrDefault("key")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "key", valid_580301
  var valid_580302 = query.getOrDefault("$.xgafv")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = newJString("1"))
  if valid_580302 != nil:
    section.add "$.xgafv", valid_580302
  var valid_580303 = query.getOrDefault("prettyPrint")
  valid_580303 = validateParameter(valid_580303, JBool, required = false,
                                 default = newJBool(true))
  if valid_580303 != nil:
    section.add "prettyPrint", valid_580303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580304: Call_LoggingBillingAccountsSinksGet_580289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a sink.
  ## 
  let valid = call_580304.validator(path, query, header, formData, body)
  let scheme = call_580304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580304.url(scheme.get, call_580304.host, call_580304.base,
                         call_580304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580304, url, valid)

proc call*(call_580305: Call_LoggingBillingAccountsSinksGet_580289;
          sinkName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## loggingBillingAccountsSinksGet
  ## Gets a sink.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   sinkName: string (required)
  ##           : Required. The resource name of the sink:
  ## "projects/[PROJECT_ID]/sinks/[SINK_ID]"
  ## "organizations/[ORGANIZATION_ID]/sinks/[SINK_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/sinks/[SINK_ID]"
  ## "folders/[FOLDER_ID]/sinks/[SINK_ID]"
  ## Example: "projects/my-project-id/sinks/my-sink-id".
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580306 = newJObject()
  var query_580307 = newJObject()
  add(query_580307, "upload_protocol", newJString(uploadProtocol))
  add(query_580307, "fields", newJString(fields))
  add(query_580307, "quotaUser", newJString(quotaUser))
  add(path_580306, "sinkName", newJString(sinkName))
  add(query_580307, "alt", newJString(alt))
  add(query_580307, "oauth_token", newJString(oauthToken))
  add(query_580307, "callback", newJString(callback))
  add(query_580307, "access_token", newJString(accessToken))
  add(query_580307, "uploadType", newJString(uploadType))
  add(query_580307, "key", newJString(key))
  add(query_580307, "$.xgafv", newJString(Xgafv))
  add(query_580307, "prettyPrint", newJBool(prettyPrint))
  result = call_580305.call(path_580306, query_580307, nil, nil, nil)

var loggingBillingAccountsSinksGet* = Call_LoggingBillingAccountsSinksGet_580289(
    name: "loggingBillingAccountsSinksGet", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{sinkName}",
    validator: validate_LoggingBillingAccountsSinksGet_580290, base: "/",
    url: url_LoggingBillingAccountsSinksGet_580291, schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsSinksPatch_580350 = ref object of OpenApiRestCall_579408
proc url_LoggingBillingAccountsSinksPatch_580352(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "sinkName" in path, "`sinkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "sinkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingBillingAccountsSinksPatch_580351(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a sink. This method replaces the following fields in the existing sink with values from the new sink: destination, and filter.The updated sink might also have a new writer_identity; see the unique_writer_identity field.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sinkName: JString (required)
  ##           : Required. The full resource name of the sink to update, including the parent resource and the sink identifier:
  ## "projects/[PROJECT_ID]/sinks/[SINK_ID]"
  ## "organizations/[ORGANIZATION_ID]/sinks/[SINK_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/sinks/[SINK_ID]"
  ## "folders/[FOLDER_ID]/sinks/[SINK_ID]"
  ## Example: "projects/my-project-id/sinks/my-sink-id".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sinkName` field"
  var valid_580353 = path.getOrDefault("sinkName")
  valid_580353 = validateParameter(valid_580353, JString, required = true,
                                 default = nil)
  if valid_580353 != nil:
    section.add "sinkName", valid_580353
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
  ##   uniqueWriterIdentity: JBool
  ##                       : Optional. See sinks.create for a description of this field. When updating a sink, the effect of this field on the value of writer_identity in the updated sink depends on both the old and new values of this field:
  ## If the old and new values of this field are both false or both true, then there is no change to the sink's writer_identity.
  ## If the old value is false and the new value is true, then writer_identity is changed to a unique service account.
  ## It is an error if the old value is true and the new value is set to false or defaulted to false.
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
  ##   updateMask: JString
  ##             : Optional. Field mask that specifies the fields in sink that need an update. A sink field will be overwritten if, and only if, it is in the update mask. name and output only fields cannot be updated.An empty updateMask is temporarily treated as using the following mask for backwards compatibility purposes:  destination,filter,includeChildren At some point in the future, behavior will be removed and specifying an empty updateMask will be an error.For a detailed FieldMask definition, see 
  ## https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#google.protobuf.FieldMaskExample: updateMask=filter.
  section = newJObject()
  var valid_580354 = query.getOrDefault("upload_protocol")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "upload_protocol", valid_580354
  var valid_580355 = query.getOrDefault("fields")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "fields", valid_580355
  var valid_580356 = query.getOrDefault("quotaUser")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "quotaUser", valid_580356
  var valid_580357 = query.getOrDefault("alt")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = newJString("json"))
  if valid_580357 != nil:
    section.add "alt", valid_580357
  var valid_580358 = query.getOrDefault("uniqueWriterIdentity")
  valid_580358 = validateParameter(valid_580358, JBool, required = false, default = nil)
  if valid_580358 != nil:
    section.add "uniqueWriterIdentity", valid_580358
  var valid_580359 = query.getOrDefault("oauth_token")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "oauth_token", valid_580359
  var valid_580360 = query.getOrDefault("callback")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "callback", valid_580360
  var valid_580361 = query.getOrDefault("access_token")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "access_token", valid_580361
  var valid_580362 = query.getOrDefault("uploadType")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "uploadType", valid_580362
  var valid_580363 = query.getOrDefault("key")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "key", valid_580363
  var valid_580364 = query.getOrDefault("$.xgafv")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = newJString("1"))
  if valid_580364 != nil:
    section.add "$.xgafv", valid_580364
  var valid_580365 = query.getOrDefault("prettyPrint")
  valid_580365 = validateParameter(valid_580365, JBool, required = false,
                                 default = newJBool(true))
  if valid_580365 != nil:
    section.add "prettyPrint", valid_580365
  var valid_580366 = query.getOrDefault("updateMask")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "updateMask", valid_580366
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

proc call*(call_580368: Call_LoggingBillingAccountsSinksPatch_580350;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a sink. This method replaces the following fields in the existing sink with values from the new sink: destination, and filter.The updated sink might also have a new writer_identity; see the unique_writer_identity field.
  ## 
  let valid = call_580368.validator(path, query, header, formData, body)
  let scheme = call_580368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580368.url(scheme.get, call_580368.host, call_580368.base,
                         call_580368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580368, url, valid)

proc call*(call_580369: Call_LoggingBillingAccountsSinksPatch_580350;
          sinkName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          uniqueWriterIdentity: bool = false; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## loggingBillingAccountsSinksPatch
  ## Updates a sink. This method replaces the following fields in the existing sink with values from the new sink: destination, and filter.The updated sink might also have a new writer_identity; see the unique_writer_identity field.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   sinkName: string (required)
  ##           : Required. The full resource name of the sink to update, including the parent resource and the sink identifier:
  ## "projects/[PROJECT_ID]/sinks/[SINK_ID]"
  ## "organizations/[ORGANIZATION_ID]/sinks/[SINK_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/sinks/[SINK_ID]"
  ## "folders/[FOLDER_ID]/sinks/[SINK_ID]"
  ## Example: "projects/my-project-id/sinks/my-sink-id".
  ##   alt: string
  ##      : Data format for response.
  ##   uniqueWriterIdentity: bool
  ##                       : Optional. See sinks.create for a description of this field. When updating a sink, the effect of this field on the value of writer_identity in the updated sink depends on both the old and new values of this field:
  ## If the old and new values of this field are both false or both true, then there is no change to the sink's writer_identity.
  ## If the old value is false and the new value is true, then writer_identity is changed to a unique service account.
  ## It is an error if the old value is true and the new value is set to false or defaulted to false.
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
  ##   updateMask: string
  ##             : Optional. Field mask that specifies the fields in sink that need an update. A sink field will be overwritten if, and only if, it is in the update mask. name and output only fields cannot be updated.An empty updateMask is temporarily treated as using the following mask for backwards compatibility purposes:  destination,filter,includeChildren At some point in the future, behavior will be removed and specifying an empty updateMask will be an error.For a detailed FieldMask definition, see 
  ## https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#google.protobuf.FieldMaskExample: updateMask=filter.
  var path_580370 = newJObject()
  var query_580371 = newJObject()
  var body_580372 = newJObject()
  add(query_580371, "upload_protocol", newJString(uploadProtocol))
  add(query_580371, "fields", newJString(fields))
  add(query_580371, "quotaUser", newJString(quotaUser))
  add(path_580370, "sinkName", newJString(sinkName))
  add(query_580371, "alt", newJString(alt))
  add(query_580371, "uniqueWriterIdentity", newJBool(uniqueWriterIdentity))
  add(query_580371, "oauth_token", newJString(oauthToken))
  add(query_580371, "callback", newJString(callback))
  add(query_580371, "access_token", newJString(accessToken))
  add(query_580371, "uploadType", newJString(uploadType))
  add(query_580371, "key", newJString(key))
  add(query_580371, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580372 = body
  add(query_580371, "prettyPrint", newJBool(prettyPrint))
  add(query_580371, "updateMask", newJString(updateMask))
  result = call_580369.call(path_580370, query_580371, nil, nil, body_580372)

var loggingBillingAccountsSinksPatch* = Call_LoggingBillingAccountsSinksPatch_580350(
    name: "loggingBillingAccountsSinksPatch", meth: HttpMethod.HttpPatch,
    host: "logging.googleapis.com", route: "/v2/{sinkName}",
    validator: validate_LoggingBillingAccountsSinksPatch_580351, base: "/",
    url: url_LoggingBillingAccountsSinksPatch_580352, schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsSinksDelete_580331 = ref object of OpenApiRestCall_579408
proc url_LoggingBillingAccountsSinksDelete_580333(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "sinkName" in path, "`sinkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "sinkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingBillingAccountsSinksDelete_580332(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a sink. If the sink has a unique writer_identity, then that service account is also deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sinkName: JString (required)
  ##           : Required. The full resource name of the sink to delete, including the parent resource and the sink identifier:
  ## "projects/[PROJECT_ID]/sinks/[SINK_ID]"
  ## "organizations/[ORGANIZATION_ID]/sinks/[SINK_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/sinks/[SINK_ID]"
  ## "folders/[FOLDER_ID]/sinks/[SINK_ID]"
  ## Example: "projects/my-project-id/sinks/my-sink-id".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sinkName` field"
  var valid_580334 = path.getOrDefault("sinkName")
  valid_580334 = validateParameter(valid_580334, JString, required = true,
                                 default = nil)
  if valid_580334 != nil:
    section.add "sinkName", valid_580334
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
  var valid_580335 = query.getOrDefault("upload_protocol")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "upload_protocol", valid_580335
  var valid_580336 = query.getOrDefault("fields")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "fields", valid_580336
  var valid_580337 = query.getOrDefault("quotaUser")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "quotaUser", valid_580337
  var valid_580338 = query.getOrDefault("alt")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = newJString("json"))
  if valid_580338 != nil:
    section.add "alt", valid_580338
  var valid_580339 = query.getOrDefault("oauth_token")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "oauth_token", valid_580339
  var valid_580340 = query.getOrDefault("callback")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "callback", valid_580340
  var valid_580341 = query.getOrDefault("access_token")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "access_token", valid_580341
  var valid_580342 = query.getOrDefault("uploadType")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "uploadType", valid_580342
  var valid_580343 = query.getOrDefault("key")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "key", valid_580343
  var valid_580344 = query.getOrDefault("$.xgafv")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = newJString("1"))
  if valid_580344 != nil:
    section.add "$.xgafv", valid_580344
  var valid_580345 = query.getOrDefault("prettyPrint")
  valid_580345 = validateParameter(valid_580345, JBool, required = false,
                                 default = newJBool(true))
  if valid_580345 != nil:
    section.add "prettyPrint", valid_580345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580346: Call_LoggingBillingAccountsSinksDelete_580331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a sink. If the sink has a unique writer_identity, then that service account is also deleted.
  ## 
  let valid = call_580346.validator(path, query, header, formData, body)
  let scheme = call_580346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580346.url(scheme.get, call_580346.host, call_580346.base,
                         call_580346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580346, url, valid)

proc call*(call_580347: Call_LoggingBillingAccountsSinksDelete_580331;
          sinkName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## loggingBillingAccountsSinksDelete
  ## Deletes a sink. If the sink has a unique writer_identity, then that service account is also deleted.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   sinkName: string (required)
  ##           : Required. The full resource name of the sink to delete, including the parent resource and the sink identifier:
  ## "projects/[PROJECT_ID]/sinks/[SINK_ID]"
  ## "organizations/[ORGANIZATION_ID]/sinks/[SINK_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/sinks/[SINK_ID]"
  ## "folders/[FOLDER_ID]/sinks/[SINK_ID]"
  ## Example: "projects/my-project-id/sinks/my-sink-id".
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580348 = newJObject()
  var query_580349 = newJObject()
  add(query_580349, "upload_protocol", newJString(uploadProtocol))
  add(query_580349, "fields", newJString(fields))
  add(query_580349, "quotaUser", newJString(quotaUser))
  add(path_580348, "sinkName", newJString(sinkName))
  add(query_580349, "alt", newJString(alt))
  add(query_580349, "oauth_token", newJString(oauthToken))
  add(query_580349, "callback", newJString(callback))
  add(query_580349, "access_token", newJString(accessToken))
  add(query_580349, "uploadType", newJString(uploadType))
  add(query_580349, "key", newJString(key))
  add(query_580349, "$.xgafv", newJString(Xgafv))
  add(query_580349, "prettyPrint", newJBool(prettyPrint))
  result = call_580347.call(path_580348, query_580349, nil, nil, nil)

var loggingBillingAccountsSinksDelete* = Call_LoggingBillingAccountsSinksDelete_580331(
    name: "loggingBillingAccountsSinksDelete", meth: HttpMethod.HttpDelete,
    host: "logging.googleapis.com", route: "/v2/{sinkName}",
    validator: validate_LoggingBillingAccountsSinksDelete_580332, base: "/",
    url: url_LoggingBillingAccountsSinksDelete_580333, schemes: {Scheme.Https})
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
