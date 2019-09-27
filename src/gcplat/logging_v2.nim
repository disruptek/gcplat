
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "logging"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LoggingEntriesList_593677 = ref object of OpenApiRestCall_593408
proc url_LoggingEntriesList_593679(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LoggingEntriesList_593678(path: JsonNode; query: JsonNode;
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

proc call*(call_593838: Call_LoggingEntriesList_593677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists log entries. Use this method to retrieve log entries that originated from a project/folder/organization/billing account. For ways to export log entries, see Exporting Logs.
  ## 
  let valid = call_593838.validator(path, query, header, formData, body)
  let scheme = call_593838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593838.url(scheme.get, call_593838.host, call_593838.base,
                         call_593838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593838, url, valid)

proc call*(call_593909: Call_LoggingEntriesList_593677;
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

var loggingEntriesList* = Call_LoggingEntriesList_593677(
    name: "loggingEntriesList", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2/entries:list",
    validator: validate_LoggingEntriesList_593678, base: "/",
    url: url_LoggingEntriesList_593679, schemes: {Scheme.Https})
type
  Call_LoggingEntriesWrite_593951 = ref object of OpenApiRestCall_593408
proc url_LoggingEntriesWrite_593953(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LoggingEntriesWrite_593952(path: JsonNode; query: JsonNode;
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

proc call*(call_593966: Call_LoggingEntriesWrite_593951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Writes log entries to Logging. This API method is the only way to send log entries to Logging. This method is used, directly or indirectly, by the Logging agent (fluentd) and all logging libraries configured to use Logging. A single request may contain log entries for a maximum of 1000 different resources (projects, organizations, billing accounts or folders)
  ## 
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_LoggingEntriesWrite_593951;
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

var loggingEntriesWrite* = Call_LoggingEntriesWrite_593951(
    name: "loggingEntriesWrite", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2/entries:write",
    validator: validate_LoggingEntriesWrite_593952, base: "/",
    url: url_LoggingEntriesWrite_593953, schemes: {Scheme.Https})
type
  Call_LoggingMonitoredResourceDescriptorsList_593970 = ref object of OpenApiRestCall_593408
proc url_LoggingMonitoredResourceDescriptorsList_593972(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LoggingMonitoredResourceDescriptorsList_593971(path: JsonNode;
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
  var valid_593975 = query.getOrDefault("pageToken")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "pageToken", valid_593975
  var valid_593976 = query.getOrDefault("quotaUser")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "quotaUser", valid_593976
  var valid_593977 = query.getOrDefault("alt")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = newJString("json"))
  if valid_593977 != nil:
    section.add "alt", valid_593977
  var valid_593978 = query.getOrDefault("oauth_token")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "oauth_token", valid_593978
  var valid_593979 = query.getOrDefault("callback")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "callback", valid_593979
  var valid_593980 = query.getOrDefault("access_token")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "access_token", valid_593980
  var valid_593981 = query.getOrDefault("uploadType")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "uploadType", valid_593981
  var valid_593982 = query.getOrDefault("key")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "key", valid_593982
  var valid_593983 = query.getOrDefault("$.xgafv")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = newJString("1"))
  if valid_593983 != nil:
    section.add "$.xgafv", valid_593983
  var valid_593984 = query.getOrDefault("pageSize")
  valid_593984 = validateParameter(valid_593984, JInt, required = false, default = nil)
  if valid_593984 != nil:
    section.add "pageSize", valid_593984
  var valid_593985 = query.getOrDefault("prettyPrint")
  valid_593985 = validateParameter(valid_593985, JBool, required = false,
                                 default = newJBool(true))
  if valid_593985 != nil:
    section.add "prettyPrint", valid_593985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593986: Call_LoggingMonitoredResourceDescriptorsList_593970;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the descriptors for monitored resource types used by Logging.
  ## 
  let valid = call_593986.validator(path, query, header, formData, body)
  let scheme = call_593986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593986.url(scheme.get, call_593986.host, call_593986.base,
                         call_593986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593986, url, valid)

proc call*(call_593987: Call_LoggingMonitoredResourceDescriptorsList_593970;
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
  var query_593988 = newJObject()
  add(query_593988, "upload_protocol", newJString(uploadProtocol))
  add(query_593988, "fields", newJString(fields))
  add(query_593988, "pageToken", newJString(pageToken))
  add(query_593988, "quotaUser", newJString(quotaUser))
  add(query_593988, "alt", newJString(alt))
  add(query_593988, "oauth_token", newJString(oauthToken))
  add(query_593988, "callback", newJString(callback))
  add(query_593988, "access_token", newJString(accessToken))
  add(query_593988, "uploadType", newJString(uploadType))
  add(query_593988, "key", newJString(key))
  add(query_593988, "$.xgafv", newJString(Xgafv))
  add(query_593988, "pageSize", newJInt(pageSize))
  add(query_593988, "prettyPrint", newJBool(prettyPrint))
  result = call_593987.call(nil, query_593988, nil, nil, nil)

var loggingMonitoredResourceDescriptorsList* = Call_LoggingMonitoredResourceDescriptorsList_593970(
    name: "loggingMonitoredResourceDescriptorsList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/monitoredResourceDescriptors",
    validator: validate_LoggingMonitoredResourceDescriptorsList_593971, base: "/",
    url: url_LoggingMonitoredResourceDescriptorsList_593972,
    schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsLogsDelete_593989 = ref object of OpenApiRestCall_593408
proc url_LoggingBillingAccountsLogsDelete_593991(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "logName" in path, "`logName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "logName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingBillingAccountsLogsDelete_593990(path: JsonNode;
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
  var valid_594006 = path.getOrDefault("logName")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "logName", valid_594006
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
  var valid_594007 = query.getOrDefault("upload_protocol")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "upload_protocol", valid_594007
  var valid_594008 = query.getOrDefault("fields")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "fields", valid_594008
  var valid_594009 = query.getOrDefault("quotaUser")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "quotaUser", valid_594009
  var valid_594010 = query.getOrDefault("alt")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = newJString("json"))
  if valid_594010 != nil:
    section.add "alt", valid_594010
  var valid_594011 = query.getOrDefault("oauth_token")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "oauth_token", valid_594011
  var valid_594012 = query.getOrDefault("callback")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "callback", valid_594012
  var valid_594013 = query.getOrDefault("access_token")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "access_token", valid_594013
  var valid_594014 = query.getOrDefault("uploadType")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "uploadType", valid_594014
  var valid_594015 = query.getOrDefault("key")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "key", valid_594015
  var valid_594016 = query.getOrDefault("$.xgafv")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = newJString("1"))
  if valid_594016 != nil:
    section.add "$.xgafv", valid_594016
  var valid_594017 = query.getOrDefault("prettyPrint")
  valid_594017 = validateParameter(valid_594017, JBool, required = false,
                                 default = newJBool(true))
  if valid_594017 != nil:
    section.add "prettyPrint", valid_594017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594018: Call_LoggingBillingAccountsLogsDelete_593989;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all the log entries in a log. The log reappears if it receives new entries. Log entries written shortly before the delete operation might not be deleted.
  ## 
  let valid = call_594018.validator(path, query, header, formData, body)
  let scheme = call_594018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594018.url(scheme.get, call_594018.host, call_594018.base,
                         call_594018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594018, url, valid)

proc call*(call_594019: Call_LoggingBillingAccountsLogsDelete_593989;
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
  var path_594020 = newJObject()
  var query_594021 = newJObject()
  add(query_594021, "upload_protocol", newJString(uploadProtocol))
  add(query_594021, "fields", newJString(fields))
  add(query_594021, "quotaUser", newJString(quotaUser))
  add(query_594021, "alt", newJString(alt))
  add(query_594021, "oauth_token", newJString(oauthToken))
  add(query_594021, "callback", newJString(callback))
  add(query_594021, "access_token", newJString(accessToken))
  add(query_594021, "uploadType", newJString(uploadType))
  add(path_594020, "logName", newJString(logName))
  add(query_594021, "key", newJString(key))
  add(query_594021, "$.xgafv", newJString(Xgafv))
  add(query_594021, "prettyPrint", newJBool(prettyPrint))
  result = call_594019.call(path_594020, query_594021, nil, nil, nil)

var loggingBillingAccountsLogsDelete* = Call_LoggingBillingAccountsLogsDelete_593989(
    name: "loggingBillingAccountsLogsDelete", meth: HttpMethod.HttpDelete,
    host: "logging.googleapis.com", route: "/v2/{logName}",
    validator: validate_LoggingBillingAccountsLogsDelete_593990, base: "/",
    url: url_LoggingBillingAccountsLogsDelete_593991, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsUpdate_594041 = ref object of OpenApiRestCall_593408
proc url_LoggingProjectsMetricsUpdate_594043(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "metricName" in path, "`metricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "metricName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingProjectsMetricsUpdate_594042(path: JsonNode; query: JsonNode;
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
  var valid_594044 = path.getOrDefault("metricName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "metricName", valid_594044
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
  var valid_594045 = query.getOrDefault("upload_protocol")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "upload_protocol", valid_594045
  var valid_594046 = query.getOrDefault("fields")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "fields", valid_594046
  var valid_594047 = query.getOrDefault("quotaUser")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "quotaUser", valid_594047
  var valid_594048 = query.getOrDefault("alt")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = newJString("json"))
  if valid_594048 != nil:
    section.add "alt", valid_594048
  var valid_594049 = query.getOrDefault("oauth_token")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "oauth_token", valid_594049
  var valid_594050 = query.getOrDefault("callback")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "callback", valid_594050
  var valid_594051 = query.getOrDefault("access_token")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "access_token", valid_594051
  var valid_594052 = query.getOrDefault("uploadType")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "uploadType", valid_594052
  var valid_594053 = query.getOrDefault("key")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "key", valid_594053
  var valid_594054 = query.getOrDefault("$.xgafv")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = newJString("1"))
  if valid_594054 != nil:
    section.add "$.xgafv", valid_594054
  var valid_594055 = query.getOrDefault("prettyPrint")
  valid_594055 = validateParameter(valid_594055, JBool, required = false,
                                 default = newJBool(true))
  if valid_594055 != nil:
    section.add "prettyPrint", valid_594055
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

proc call*(call_594057: Call_LoggingProjectsMetricsUpdate_594041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a logs-based metric.
  ## 
  let valid = call_594057.validator(path, query, header, formData, body)
  let scheme = call_594057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594057.url(scheme.get, call_594057.host, call_594057.base,
                         call_594057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594057, url, valid)

proc call*(call_594058: Call_LoggingProjectsMetricsUpdate_594041;
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
  var path_594059 = newJObject()
  var query_594060 = newJObject()
  var body_594061 = newJObject()
  add(query_594060, "upload_protocol", newJString(uploadProtocol))
  add(query_594060, "fields", newJString(fields))
  add(query_594060, "quotaUser", newJString(quotaUser))
  add(query_594060, "alt", newJString(alt))
  add(query_594060, "oauth_token", newJString(oauthToken))
  add(query_594060, "callback", newJString(callback))
  add(query_594060, "access_token", newJString(accessToken))
  add(query_594060, "uploadType", newJString(uploadType))
  add(path_594059, "metricName", newJString(metricName))
  add(query_594060, "key", newJString(key))
  add(query_594060, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594061 = body
  add(query_594060, "prettyPrint", newJBool(prettyPrint))
  result = call_594058.call(path_594059, query_594060, nil, nil, body_594061)

var loggingProjectsMetricsUpdate* = Call_LoggingProjectsMetricsUpdate_594041(
    name: "loggingProjectsMetricsUpdate", meth: HttpMethod.HttpPut,
    host: "logging.googleapis.com", route: "/v2/{metricName}",
    validator: validate_LoggingProjectsMetricsUpdate_594042, base: "/",
    url: url_LoggingProjectsMetricsUpdate_594043, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsGet_594022 = ref object of OpenApiRestCall_593408
proc url_LoggingProjectsMetricsGet_594024(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "metricName" in path, "`metricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "metricName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingProjectsMetricsGet_594023(path: JsonNode; query: JsonNode;
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
  var valid_594025 = path.getOrDefault("metricName")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "metricName", valid_594025
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
  var valid_594026 = query.getOrDefault("upload_protocol")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "upload_protocol", valid_594026
  var valid_594027 = query.getOrDefault("fields")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "fields", valid_594027
  var valid_594028 = query.getOrDefault("quotaUser")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "quotaUser", valid_594028
  var valid_594029 = query.getOrDefault("alt")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = newJString("json"))
  if valid_594029 != nil:
    section.add "alt", valid_594029
  var valid_594030 = query.getOrDefault("oauth_token")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "oauth_token", valid_594030
  var valid_594031 = query.getOrDefault("callback")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "callback", valid_594031
  var valid_594032 = query.getOrDefault("access_token")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "access_token", valid_594032
  var valid_594033 = query.getOrDefault("uploadType")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "uploadType", valid_594033
  var valid_594034 = query.getOrDefault("key")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "key", valid_594034
  var valid_594035 = query.getOrDefault("$.xgafv")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = newJString("1"))
  if valid_594035 != nil:
    section.add "$.xgafv", valid_594035
  var valid_594036 = query.getOrDefault("prettyPrint")
  valid_594036 = validateParameter(valid_594036, JBool, required = false,
                                 default = newJBool(true))
  if valid_594036 != nil:
    section.add "prettyPrint", valid_594036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594037: Call_LoggingProjectsMetricsGet_594022; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a logs-based metric.
  ## 
  let valid = call_594037.validator(path, query, header, formData, body)
  let scheme = call_594037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594037.url(scheme.get, call_594037.host, call_594037.base,
                         call_594037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594037, url, valid)

proc call*(call_594038: Call_LoggingProjectsMetricsGet_594022; metricName: string;
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
  var path_594039 = newJObject()
  var query_594040 = newJObject()
  add(query_594040, "upload_protocol", newJString(uploadProtocol))
  add(query_594040, "fields", newJString(fields))
  add(query_594040, "quotaUser", newJString(quotaUser))
  add(query_594040, "alt", newJString(alt))
  add(query_594040, "oauth_token", newJString(oauthToken))
  add(query_594040, "callback", newJString(callback))
  add(query_594040, "access_token", newJString(accessToken))
  add(query_594040, "uploadType", newJString(uploadType))
  add(path_594039, "metricName", newJString(metricName))
  add(query_594040, "key", newJString(key))
  add(query_594040, "$.xgafv", newJString(Xgafv))
  add(query_594040, "prettyPrint", newJBool(prettyPrint))
  result = call_594038.call(path_594039, query_594040, nil, nil, nil)

var loggingProjectsMetricsGet* = Call_LoggingProjectsMetricsGet_594022(
    name: "loggingProjectsMetricsGet", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{metricName}",
    validator: validate_LoggingProjectsMetricsGet_594023, base: "/",
    url: url_LoggingProjectsMetricsGet_594024, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsDelete_594062 = ref object of OpenApiRestCall_593408
proc url_LoggingProjectsMetricsDelete_594064(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "metricName" in path, "`metricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "metricName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingProjectsMetricsDelete_594063(path: JsonNode; query: JsonNode;
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
  var valid_594065 = path.getOrDefault("metricName")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "metricName", valid_594065
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
  var valid_594066 = query.getOrDefault("upload_protocol")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "upload_protocol", valid_594066
  var valid_594067 = query.getOrDefault("fields")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "fields", valid_594067
  var valid_594068 = query.getOrDefault("quotaUser")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "quotaUser", valid_594068
  var valid_594069 = query.getOrDefault("alt")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = newJString("json"))
  if valid_594069 != nil:
    section.add "alt", valid_594069
  var valid_594070 = query.getOrDefault("oauth_token")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "oauth_token", valid_594070
  var valid_594071 = query.getOrDefault("callback")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "callback", valid_594071
  var valid_594072 = query.getOrDefault("access_token")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "access_token", valid_594072
  var valid_594073 = query.getOrDefault("uploadType")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "uploadType", valid_594073
  var valid_594074 = query.getOrDefault("key")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "key", valid_594074
  var valid_594075 = query.getOrDefault("$.xgafv")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = newJString("1"))
  if valid_594075 != nil:
    section.add "$.xgafv", valid_594075
  var valid_594076 = query.getOrDefault("prettyPrint")
  valid_594076 = validateParameter(valid_594076, JBool, required = false,
                                 default = newJBool(true))
  if valid_594076 != nil:
    section.add "prettyPrint", valid_594076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594077: Call_LoggingProjectsMetricsDelete_594062; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a logs-based metric.
  ## 
  let valid = call_594077.validator(path, query, header, formData, body)
  let scheme = call_594077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594077.url(scheme.get, call_594077.host, call_594077.base,
                         call_594077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594077, url, valid)

proc call*(call_594078: Call_LoggingProjectsMetricsDelete_594062;
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
  var path_594079 = newJObject()
  var query_594080 = newJObject()
  add(query_594080, "upload_protocol", newJString(uploadProtocol))
  add(query_594080, "fields", newJString(fields))
  add(query_594080, "quotaUser", newJString(quotaUser))
  add(query_594080, "alt", newJString(alt))
  add(query_594080, "oauth_token", newJString(oauthToken))
  add(query_594080, "callback", newJString(callback))
  add(query_594080, "access_token", newJString(accessToken))
  add(query_594080, "uploadType", newJString(uploadType))
  add(path_594079, "metricName", newJString(metricName))
  add(query_594080, "key", newJString(key))
  add(query_594080, "$.xgafv", newJString(Xgafv))
  add(query_594080, "prettyPrint", newJBool(prettyPrint))
  result = call_594078.call(path_594079, query_594080, nil, nil, nil)

var loggingProjectsMetricsDelete* = Call_LoggingProjectsMetricsDelete_594062(
    name: "loggingProjectsMetricsDelete", meth: HttpMethod.HttpDelete,
    host: "logging.googleapis.com", route: "/v2/{metricName}",
    validator: validate_LoggingProjectsMetricsDelete_594063, base: "/",
    url: url_LoggingProjectsMetricsDelete_594064, schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsExclusionsGet_594081 = ref object of OpenApiRestCall_593408
proc url_LoggingBillingAccountsExclusionsGet_594083(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingBillingAccountsExclusionsGet_594082(path: JsonNode;
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
  var valid_594084 = path.getOrDefault("name")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "name", valid_594084
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
  var valid_594085 = query.getOrDefault("upload_protocol")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "upload_protocol", valid_594085
  var valid_594086 = query.getOrDefault("fields")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "fields", valid_594086
  var valid_594087 = query.getOrDefault("quotaUser")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "quotaUser", valid_594087
  var valid_594088 = query.getOrDefault("alt")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = newJString("json"))
  if valid_594088 != nil:
    section.add "alt", valid_594088
  var valid_594089 = query.getOrDefault("oauth_token")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "oauth_token", valid_594089
  var valid_594090 = query.getOrDefault("callback")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "callback", valid_594090
  var valid_594091 = query.getOrDefault("access_token")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "access_token", valid_594091
  var valid_594092 = query.getOrDefault("uploadType")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "uploadType", valid_594092
  var valid_594093 = query.getOrDefault("key")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "key", valid_594093
  var valid_594094 = query.getOrDefault("$.xgafv")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = newJString("1"))
  if valid_594094 != nil:
    section.add "$.xgafv", valid_594094
  var valid_594095 = query.getOrDefault("prettyPrint")
  valid_594095 = validateParameter(valid_594095, JBool, required = false,
                                 default = newJBool(true))
  if valid_594095 != nil:
    section.add "prettyPrint", valid_594095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594096: Call_LoggingBillingAccountsExclusionsGet_594081;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the description of an exclusion.
  ## 
  let valid = call_594096.validator(path, query, header, formData, body)
  let scheme = call_594096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594096.url(scheme.get, call_594096.host, call_594096.base,
                         call_594096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594096, url, valid)

proc call*(call_594097: Call_LoggingBillingAccountsExclusionsGet_594081;
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
  var path_594098 = newJObject()
  var query_594099 = newJObject()
  add(query_594099, "upload_protocol", newJString(uploadProtocol))
  add(query_594099, "fields", newJString(fields))
  add(query_594099, "quotaUser", newJString(quotaUser))
  add(path_594098, "name", newJString(name))
  add(query_594099, "alt", newJString(alt))
  add(query_594099, "oauth_token", newJString(oauthToken))
  add(query_594099, "callback", newJString(callback))
  add(query_594099, "access_token", newJString(accessToken))
  add(query_594099, "uploadType", newJString(uploadType))
  add(query_594099, "key", newJString(key))
  add(query_594099, "$.xgafv", newJString(Xgafv))
  add(query_594099, "prettyPrint", newJBool(prettyPrint))
  result = call_594097.call(path_594098, query_594099, nil, nil, nil)

var loggingBillingAccountsExclusionsGet* = Call_LoggingBillingAccountsExclusionsGet_594081(
    name: "loggingBillingAccountsExclusionsGet", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{name}",
    validator: validate_LoggingBillingAccountsExclusionsGet_594082, base: "/",
    url: url_LoggingBillingAccountsExclusionsGet_594083, schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsExclusionsPatch_594119 = ref object of OpenApiRestCall_593408
proc url_LoggingBillingAccountsExclusionsPatch_594121(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingBillingAccountsExclusionsPatch_594120(path: JsonNode;
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
  var valid_594122 = path.getOrDefault("name")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "name", valid_594122
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
  var valid_594123 = query.getOrDefault("upload_protocol")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "upload_protocol", valid_594123
  var valid_594124 = query.getOrDefault("fields")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "fields", valid_594124
  var valid_594125 = query.getOrDefault("quotaUser")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "quotaUser", valid_594125
  var valid_594126 = query.getOrDefault("alt")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = newJString("json"))
  if valid_594126 != nil:
    section.add "alt", valid_594126
  var valid_594127 = query.getOrDefault("oauth_token")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "oauth_token", valid_594127
  var valid_594128 = query.getOrDefault("callback")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "callback", valid_594128
  var valid_594129 = query.getOrDefault("access_token")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "access_token", valid_594129
  var valid_594130 = query.getOrDefault("uploadType")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "uploadType", valid_594130
  var valid_594131 = query.getOrDefault("key")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "key", valid_594131
  var valid_594132 = query.getOrDefault("$.xgafv")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = newJString("1"))
  if valid_594132 != nil:
    section.add "$.xgafv", valid_594132
  var valid_594133 = query.getOrDefault("prettyPrint")
  valid_594133 = validateParameter(valid_594133, JBool, required = false,
                                 default = newJBool(true))
  if valid_594133 != nil:
    section.add "prettyPrint", valid_594133
  var valid_594134 = query.getOrDefault("updateMask")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "updateMask", valid_594134
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

proc call*(call_594136: Call_LoggingBillingAccountsExclusionsPatch_594119;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Changes one or more properties of an existing exclusion.
  ## 
  let valid = call_594136.validator(path, query, header, formData, body)
  let scheme = call_594136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594136.url(scheme.get, call_594136.host, call_594136.base,
                         call_594136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594136, url, valid)

proc call*(call_594137: Call_LoggingBillingAccountsExclusionsPatch_594119;
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
  var path_594138 = newJObject()
  var query_594139 = newJObject()
  var body_594140 = newJObject()
  add(query_594139, "upload_protocol", newJString(uploadProtocol))
  add(query_594139, "fields", newJString(fields))
  add(query_594139, "quotaUser", newJString(quotaUser))
  add(path_594138, "name", newJString(name))
  add(query_594139, "alt", newJString(alt))
  add(query_594139, "oauth_token", newJString(oauthToken))
  add(query_594139, "callback", newJString(callback))
  add(query_594139, "access_token", newJString(accessToken))
  add(query_594139, "uploadType", newJString(uploadType))
  add(query_594139, "key", newJString(key))
  add(query_594139, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594140 = body
  add(query_594139, "prettyPrint", newJBool(prettyPrint))
  add(query_594139, "updateMask", newJString(updateMask))
  result = call_594137.call(path_594138, query_594139, nil, nil, body_594140)

var loggingBillingAccountsExclusionsPatch* = Call_LoggingBillingAccountsExclusionsPatch_594119(
    name: "loggingBillingAccountsExclusionsPatch", meth: HttpMethod.HttpPatch,
    host: "logging.googleapis.com", route: "/v2/{name}",
    validator: validate_LoggingBillingAccountsExclusionsPatch_594120, base: "/",
    url: url_LoggingBillingAccountsExclusionsPatch_594121, schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsExclusionsDelete_594100 = ref object of OpenApiRestCall_593408
proc url_LoggingBillingAccountsExclusionsDelete_594102(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingBillingAccountsExclusionsDelete_594101(path: JsonNode;
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
  var valid_594103 = path.getOrDefault("name")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "name", valid_594103
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
  var valid_594104 = query.getOrDefault("upload_protocol")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "upload_protocol", valid_594104
  var valid_594105 = query.getOrDefault("fields")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "fields", valid_594105
  var valid_594106 = query.getOrDefault("quotaUser")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "quotaUser", valid_594106
  var valid_594107 = query.getOrDefault("alt")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = newJString("json"))
  if valid_594107 != nil:
    section.add "alt", valid_594107
  var valid_594108 = query.getOrDefault("oauth_token")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "oauth_token", valid_594108
  var valid_594109 = query.getOrDefault("callback")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "callback", valid_594109
  var valid_594110 = query.getOrDefault("access_token")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "access_token", valid_594110
  var valid_594111 = query.getOrDefault("uploadType")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "uploadType", valid_594111
  var valid_594112 = query.getOrDefault("key")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "key", valid_594112
  var valid_594113 = query.getOrDefault("$.xgafv")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = newJString("1"))
  if valid_594113 != nil:
    section.add "$.xgafv", valid_594113
  var valid_594114 = query.getOrDefault("prettyPrint")
  valid_594114 = validateParameter(valid_594114, JBool, required = false,
                                 default = newJBool(true))
  if valid_594114 != nil:
    section.add "prettyPrint", valid_594114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594115: Call_LoggingBillingAccountsExclusionsDelete_594100;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an exclusion.
  ## 
  let valid = call_594115.validator(path, query, header, formData, body)
  let scheme = call_594115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594115.url(scheme.get, call_594115.host, call_594115.base,
                         call_594115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594115, url, valid)

proc call*(call_594116: Call_LoggingBillingAccountsExclusionsDelete_594100;
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
  var path_594117 = newJObject()
  var query_594118 = newJObject()
  add(query_594118, "upload_protocol", newJString(uploadProtocol))
  add(query_594118, "fields", newJString(fields))
  add(query_594118, "quotaUser", newJString(quotaUser))
  add(path_594117, "name", newJString(name))
  add(query_594118, "alt", newJString(alt))
  add(query_594118, "oauth_token", newJString(oauthToken))
  add(query_594118, "callback", newJString(callback))
  add(query_594118, "access_token", newJString(accessToken))
  add(query_594118, "uploadType", newJString(uploadType))
  add(query_594118, "key", newJString(key))
  add(query_594118, "$.xgafv", newJString(Xgafv))
  add(query_594118, "prettyPrint", newJBool(prettyPrint))
  result = call_594116.call(path_594117, query_594118, nil, nil, nil)

var loggingBillingAccountsExclusionsDelete* = Call_LoggingBillingAccountsExclusionsDelete_594100(
    name: "loggingBillingAccountsExclusionsDelete", meth: HttpMethod.HttpDelete,
    host: "logging.googleapis.com", route: "/v2/{name}",
    validator: validate_LoggingBillingAccountsExclusionsDelete_594101, base: "/",
    url: url_LoggingBillingAccountsExclusionsDelete_594102,
    schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsExclusionsCreate_594162 = ref object of OpenApiRestCall_593408
proc url_LoggingBillingAccountsExclusionsCreate_594164(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_LoggingBillingAccountsExclusionsCreate_594163(path: JsonNode;
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
  var valid_594165 = path.getOrDefault("parent")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "parent", valid_594165
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
  var valid_594166 = query.getOrDefault("upload_protocol")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = nil)
  if valid_594166 != nil:
    section.add "upload_protocol", valid_594166
  var valid_594167 = query.getOrDefault("fields")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "fields", valid_594167
  var valid_594168 = query.getOrDefault("quotaUser")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "quotaUser", valid_594168
  var valid_594169 = query.getOrDefault("alt")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = newJString("json"))
  if valid_594169 != nil:
    section.add "alt", valid_594169
  var valid_594170 = query.getOrDefault("oauth_token")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "oauth_token", valid_594170
  var valid_594171 = query.getOrDefault("callback")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "callback", valid_594171
  var valid_594172 = query.getOrDefault("access_token")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "access_token", valid_594172
  var valid_594173 = query.getOrDefault("uploadType")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = nil)
  if valid_594173 != nil:
    section.add "uploadType", valid_594173
  var valid_594174 = query.getOrDefault("key")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "key", valid_594174
  var valid_594175 = query.getOrDefault("$.xgafv")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = newJString("1"))
  if valid_594175 != nil:
    section.add "$.xgafv", valid_594175
  var valid_594176 = query.getOrDefault("prettyPrint")
  valid_594176 = validateParameter(valid_594176, JBool, required = false,
                                 default = newJBool(true))
  if valid_594176 != nil:
    section.add "prettyPrint", valid_594176
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

proc call*(call_594178: Call_LoggingBillingAccountsExclusionsCreate_594162;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new exclusion in a specified parent resource. Only log entries belonging to that resource can be excluded. You can have up to 10 exclusions in a resource.
  ## 
  let valid = call_594178.validator(path, query, header, formData, body)
  let scheme = call_594178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594178.url(scheme.get, call_594178.host, call_594178.base,
                         call_594178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594178, url, valid)

proc call*(call_594179: Call_LoggingBillingAccountsExclusionsCreate_594162;
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
  var path_594180 = newJObject()
  var query_594181 = newJObject()
  var body_594182 = newJObject()
  add(query_594181, "upload_protocol", newJString(uploadProtocol))
  add(query_594181, "fields", newJString(fields))
  add(query_594181, "quotaUser", newJString(quotaUser))
  add(query_594181, "alt", newJString(alt))
  add(query_594181, "oauth_token", newJString(oauthToken))
  add(query_594181, "callback", newJString(callback))
  add(query_594181, "access_token", newJString(accessToken))
  add(query_594181, "uploadType", newJString(uploadType))
  add(path_594180, "parent", newJString(parent))
  add(query_594181, "key", newJString(key))
  add(query_594181, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594182 = body
  add(query_594181, "prettyPrint", newJBool(prettyPrint))
  result = call_594179.call(path_594180, query_594181, nil, nil, body_594182)

var loggingBillingAccountsExclusionsCreate* = Call_LoggingBillingAccountsExclusionsCreate_594162(
    name: "loggingBillingAccountsExclusionsCreate", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2/{parent}/exclusions",
    validator: validate_LoggingBillingAccountsExclusionsCreate_594163, base: "/",
    url: url_LoggingBillingAccountsExclusionsCreate_594164,
    schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsExclusionsList_594141 = ref object of OpenApiRestCall_593408
proc url_LoggingBillingAccountsExclusionsList_594143(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_LoggingBillingAccountsExclusionsList_594142(path: JsonNode;
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
  var valid_594144 = path.getOrDefault("parent")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "parent", valid_594144
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
  var valid_594145 = query.getOrDefault("upload_protocol")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "upload_protocol", valid_594145
  var valid_594146 = query.getOrDefault("fields")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "fields", valid_594146
  var valid_594147 = query.getOrDefault("pageToken")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "pageToken", valid_594147
  var valid_594148 = query.getOrDefault("quotaUser")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "quotaUser", valid_594148
  var valid_594149 = query.getOrDefault("alt")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = newJString("json"))
  if valid_594149 != nil:
    section.add "alt", valid_594149
  var valid_594150 = query.getOrDefault("oauth_token")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "oauth_token", valid_594150
  var valid_594151 = query.getOrDefault("callback")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "callback", valid_594151
  var valid_594152 = query.getOrDefault("access_token")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "access_token", valid_594152
  var valid_594153 = query.getOrDefault("uploadType")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = nil)
  if valid_594153 != nil:
    section.add "uploadType", valid_594153
  var valid_594154 = query.getOrDefault("key")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "key", valid_594154
  var valid_594155 = query.getOrDefault("$.xgafv")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = newJString("1"))
  if valid_594155 != nil:
    section.add "$.xgafv", valid_594155
  var valid_594156 = query.getOrDefault("pageSize")
  valid_594156 = validateParameter(valid_594156, JInt, required = false, default = nil)
  if valid_594156 != nil:
    section.add "pageSize", valid_594156
  var valid_594157 = query.getOrDefault("prettyPrint")
  valid_594157 = validateParameter(valid_594157, JBool, required = false,
                                 default = newJBool(true))
  if valid_594157 != nil:
    section.add "prettyPrint", valid_594157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594158: Call_LoggingBillingAccountsExclusionsList_594141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the exclusions in a parent resource.
  ## 
  let valid = call_594158.validator(path, query, header, formData, body)
  let scheme = call_594158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594158.url(scheme.get, call_594158.host, call_594158.base,
                         call_594158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594158, url, valid)

proc call*(call_594159: Call_LoggingBillingAccountsExclusionsList_594141;
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
  var path_594160 = newJObject()
  var query_594161 = newJObject()
  add(query_594161, "upload_protocol", newJString(uploadProtocol))
  add(query_594161, "fields", newJString(fields))
  add(query_594161, "pageToken", newJString(pageToken))
  add(query_594161, "quotaUser", newJString(quotaUser))
  add(query_594161, "alt", newJString(alt))
  add(query_594161, "oauth_token", newJString(oauthToken))
  add(query_594161, "callback", newJString(callback))
  add(query_594161, "access_token", newJString(accessToken))
  add(query_594161, "uploadType", newJString(uploadType))
  add(path_594160, "parent", newJString(parent))
  add(query_594161, "key", newJString(key))
  add(query_594161, "$.xgafv", newJString(Xgafv))
  add(query_594161, "pageSize", newJInt(pageSize))
  add(query_594161, "prettyPrint", newJBool(prettyPrint))
  result = call_594159.call(path_594160, query_594161, nil, nil, nil)

var loggingBillingAccountsExclusionsList* = Call_LoggingBillingAccountsExclusionsList_594141(
    name: "loggingBillingAccountsExclusionsList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{parent}/exclusions",
    validator: validate_LoggingBillingAccountsExclusionsList_594142, base: "/",
    url: url_LoggingBillingAccountsExclusionsList_594143, schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsLogsList_594183 = ref object of OpenApiRestCall_593408
proc url_LoggingBillingAccountsLogsList_594185(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_LoggingBillingAccountsLogsList_594184(path: JsonNode;
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
  var valid_594186 = path.getOrDefault("parent")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "parent", valid_594186
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
  var valid_594187 = query.getOrDefault("upload_protocol")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "upload_protocol", valid_594187
  var valid_594188 = query.getOrDefault("fields")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "fields", valid_594188
  var valid_594189 = query.getOrDefault("pageToken")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "pageToken", valid_594189
  var valid_594190 = query.getOrDefault("quotaUser")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "quotaUser", valid_594190
  var valid_594191 = query.getOrDefault("alt")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = newJString("json"))
  if valid_594191 != nil:
    section.add "alt", valid_594191
  var valid_594192 = query.getOrDefault("oauth_token")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "oauth_token", valid_594192
  var valid_594193 = query.getOrDefault("callback")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "callback", valid_594193
  var valid_594194 = query.getOrDefault("access_token")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "access_token", valid_594194
  var valid_594195 = query.getOrDefault("uploadType")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "uploadType", valid_594195
  var valid_594196 = query.getOrDefault("key")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = nil)
  if valid_594196 != nil:
    section.add "key", valid_594196
  var valid_594197 = query.getOrDefault("$.xgafv")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = newJString("1"))
  if valid_594197 != nil:
    section.add "$.xgafv", valid_594197
  var valid_594198 = query.getOrDefault("pageSize")
  valid_594198 = validateParameter(valid_594198, JInt, required = false, default = nil)
  if valid_594198 != nil:
    section.add "pageSize", valid_594198
  var valid_594199 = query.getOrDefault("prettyPrint")
  valid_594199 = validateParameter(valid_594199, JBool, required = false,
                                 default = newJBool(true))
  if valid_594199 != nil:
    section.add "prettyPrint", valid_594199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594200: Call_LoggingBillingAccountsLogsList_594183; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the logs in projects, organizations, folders, or billing accounts. Only logs that have entries are listed.
  ## 
  let valid = call_594200.validator(path, query, header, formData, body)
  let scheme = call_594200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594200.url(scheme.get, call_594200.host, call_594200.base,
                         call_594200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594200, url, valid)

proc call*(call_594201: Call_LoggingBillingAccountsLogsList_594183; parent: string;
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
  var path_594202 = newJObject()
  var query_594203 = newJObject()
  add(query_594203, "upload_protocol", newJString(uploadProtocol))
  add(query_594203, "fields", newJString(fields))
  add(query_594203, "pageToken", newJString(pageToken))
  add(query_594203, "quotaUser", newJString(quotaUser))
  add(query_594203, "alt", newJString(alt))
  add(query_594203, "oauth_token", newJString(oauthToken))
  add(query_594203, "callback", newJString(callback))
  add(query_594203, "access_token", newJString(accessToken))
  add(query_594203, "uploadType", newJString(uploadType))
  add(path_594202, "parent", newJString(parent))
  add(query_594203, "key", newJString(key))
  add(query_594203, "$.xgafv", newJString(Xgafv))
  add(query_594203, "pageSize", newJInt(pageSize))
  add(query_594203, "prettyPrint", newJBool(prettyPrint))
  result = call_594201.call(path_594202, query_594203, nil, nil, nil)

var loggingBillingAccountsLogsList* = Call_LoggingBillingAccountsLogsList_594183(
    name: "loggingBillingAccountsLogsList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{parent}/logs",
    validator: validate_LoggingBillingAccountsLogsList_594184, base: "/",
    url: url_LoggingBillingAccountsLogsList_594185, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsCreate_594225 = ref object of OpenApiRestCall_593408
proc url_LoggingProjectsMetricsCreate_594227(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_LoggingProjectsMetricsCreate_594226(path: JsonNode; query: JsonNode;
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
  var valid_594228 = path.getOrDefault("parent")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "parent", valid_594228
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
  var valid_594229 = query.getOrDefault("upload_protocol")
  valid_594229 = validateParameter(valid_594229, JString, required = false,
                                 default = nil)
  if valid_594229 != nil:
    section.add "upload_protocol", valid_594229
  var valid_594230 = query.getOrDefault("fields")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = nil)
  if valid_594230 != nil:
    section.add "fields", valid_594230
  var valid_594231 = query.getOrDefault("quotaUser")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = nil)
  if valid_594231 != nil:
    section.add "quotaUser", valid_594231
  var valid_594232 = query.getOrDefault("alt")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = newJString("json"))
  if valid_594232 != nil:
    section.add "alt", valid_594232
  var valid_594233 = query.getOrDefault("oauth_token")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "oauth_token", valid_594233
  var valid_594234 = query.getOrDefault("callback")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "callback", valid_594234
  var valid_594235 = query.getOrDefault("access_token")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "access_token", valid_594235
  var valid_594236 = query.getOrDefault("uploadType")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "uploadType", valid_594236
  var valid_594237 = query.getOrDefault("key")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = nil)
  if valid_594237 != nil:
    section.add "key", valid_594237
  var valid_594238 = query.getOrDefault("$.xgafv")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = newJString("1"))
  if valid_594238 != nil:
    section.add "$.xgafv", valid_594238
  var valid_594239 = query.getOrDefault("prettyPrint")
  valid_594239 = validateParameter(valid_594239, JBool, required = false,
                                 default = newJBool(true))
  if valid_594239 != nil:
    section.add "prettyPrint", valid_594239
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

proc call*(call_594241: Call_LoggingProjectsMetricsCreate_594225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a logs-based metric.
  ## 
  let valid = call_594241.validator(path, query, header, formData, body)
  let scheme = call_594241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594241.url(scheme.get, call_594241.host, call_594241.base,
                         call_594241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594241, url, valid)

proc call*(call_594242: Call_LoggingProjectsMetricsCreate_594225; parent: string;
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
  var path_594243 = newJObject()
  var query_594244 = newJObject()
  var body_594245 = newJObject()
  add(query_594244, "upload_protocol", newJString(uploadProtocol))
  add(query_594244, "fields", newJString(fields))
  add(query_594244, "quotaUser", newJString(quotaUser))
  add(query_594244, "alt", newJString(alt))
  add(query_594244, "oauth_token", newJString(oauthToken))
  add(query_594244, "callback", newJString(callback))
  add(query_594244, "access_token", newJString(accessToken))
  add(query_594244, "uploadType", newJString(uploadType))
  add(path_594243, "parent", newJString(parent))
  add(query_594244, "key", newJString(key))
  add(query_594244, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594245 = body
  add(query_594244, "prettyPrint", newJBool(prettyPrint))
  result = call_594242.call(path_594243, query_594244, nil, nil, body_594245)

var loggingProjectsMetricsCreate* = Call_LoggingProjectsMetricsCreate_594225(
    name: "loggingProjectsMetricsCreate", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2/{parent}/metrics",
    validator: validate_LoggingProjectsMetricsCreate_594226, base: "/",
    url: url_LoggingProjectsMetricsCreate_594227, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsList_594204 = ref object of OpenApiRestCall_593408
proc url_LoggingProjectsMetricsList_594206(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_LoggingProjectsMetricsList_594205(path: JsonNode; query: JsonNode;
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
  var valid_594207 = path.getOrDefault("parent")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "parent", valid_594207
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
  var valid_594208 = query.getOrDefault("upload_protocol")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "upload_protocol", valid_594208
  var valid_594209 = query.getOrDefault("fields")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "fields", valid_594209
  var valid_594210 = query.getOrDefault("pageToken")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "pageToken", valid_594210
  var valid_594211 = query.getOrDefault("quotaUser")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "quotaUser", valid_594211
  var valid_594212 = query.getOrDefault("alt")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = newJString("json"))
  if valid_594212 != nil:
    section.add "alt", valid_594212
  var valid_594213 = query.getOrDefault("oauth_token")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = nil)
  if valid_594213 != nil:
    section.add "oauth_token", valid_594213
  var valid_594214 = query.getOrDefault("callback")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "callback", valid_594214
  var valid_594215 = query.getOrDefault("access_token")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "access_token", valid_594215
  var valid_594216 = query.getOrDefault("uploadType")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "uploadType", valid_594216
  var valid_594217 = query.getOrDefault("key")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = nil)
  if valid_594217 != nil:
    section.add "key", valid_594217
  var valid_594218 = query.getOrDefault("$.xgafv")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = newJString("1"))
  if valid_594218 != nil:
    section.add "$.xgafv", valid_594218
  var valid_594219 = query.getOrDefault("pageSize")
  valid_594219 = validateParameter(valid_594219, JInt, required = false, default = nil)
  if valid_594219 != nil:
    section.add "pageSize", valid_594219
  var valid_594220 = query.getOrDefault("prettyPrint")
  valid_594220 = validateParameter(valid_594220, JBool, required = false,
                                 default = newJBool(true))
  if valid_594220 != nil:
    section.add "prettyPrint", valid_594220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594221: Call_LoggingProjectsMetricsList_594204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists logs-based metrics.
  ## 
  let valid = call_594221.validator(path, query, header, formData, body)
  let scheme = call_594221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594221.url(scheme.get, call_594221.host, call_594221.base,
                         call_594221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594221, url, valid)

proc call*(call_594222: Call_LoggingProjectsMetricsList_594204; parent: string;
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
  var path_594223 = newJObject()
  var query_594224 = newJObject()
  add(query_594224, "upload_protocol", newJString(uploadProtocol))
  add(query_594224, "fields", newJString(fields))
  add(query_594224, "pageToken", newJString(pageToken))
  add(query_594224, "quotaUser", newJString(quotaUser))
  add(query_594224, "alt", newJString(alt))
  add(query_594224, "oauth_token", newJString(oauthToken))
  add(query_594224, "callback", newJString(callback))
  add(query_594224, "access_token", newJString(accessToken))
  add(query_594224, "uploadType", newJString(uploadType))
  add(path_594223, "parent", newJString(parent))
  add(query_594224, "key", newJString(key))
  add(query_594224, "$.xgafv", newJString(Xgafv))
  add(query_594224, "pageSize", newJInt(pageSize))
  add(query_594224, "prettyPrint", newJBool(prettyPrint))
  result = call_594222.call(path_594223, query_594224, nil, nil, nil)

var loggingProjectsMetricsList* = Call_LoggingProjectsMetricsList_594204(
    name: "loggingProjectsMetricsList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{parent}/metrics",
    validator: validate_LoggingProjectsMetricsList_594205, base: "/",
    url: url_LoggingProjectsMetricsList_594206, schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsSinksCreate_594267 = ref object of OpenApiRestCall_593408
proc url_LoggingBillingAccountsSinksCreate_594269(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_LoggingBillingAccountsSinksCreate_594268(path: JsonNode;
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
  var valid_594270 = path.getOrDefault("parent")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "parent", valid_594270
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
  var valid_594271 = query.getOrDefault("upload_protocol")
  valid_594271 = validateParameter(valid_594271, JString, required = false,
                                 default = nil)
  if valid_594271 != nil:
    section.add "upload_protocol", valid_594271
  var valid_594272 = query.getOrDefault("fields")
  valid_594272 = validateParameter(valid_594272, JString, required = false,
                                 default = nil)
  if valid_594272 != nil:
    section.add "fields", valid_594272
  var valid_594273 = query.getOrDefault("quotaUser")
  valid_594273 = validateParameter(valid_594273, JString, required = false,
                                 default = nil)
  if valid_594273 != nil:
    section.add "quotaUser", valid_594273
  var valid_594274 = query.getOrDefault("alt")
  valid_594274 = validateParameter(valid_594274, JString, required = false,
                                 default = newJString("json"))
  if valid_594274 != nil:
    section.add "alt", valid_594274
  var valid_594275 = query.getOrDefault("uniqueWriterIdentity")
  valid_594275 = validateParameter(valid_594275, JBool, required = false, default = nil)
  if valid_594275 != nil:
    section.add "uniqueWriterIdentity", valid_594275
  var valid_594276 = query.getOrDefault("oauth_token")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = nil)
  if valid_594276 != nil:
    section.add "oauth_token", valid_594276
  var valid_594277 = query.getOrDefault("callback")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = nil)
  if valid_594277 != nil:
    section.add "callback", valid_594277
  var valid_594278 = query.getOrDefault("access_token")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "access_token", valid_594278
  var valid_594279 = query.getOrDefault("uploadType")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "uploadType", valid_594279
  var valid_594280 = query.getOrDefault("key")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = nil)
  if valid_594280 != nil:
    section.add "key", valid_594280
  var valid_594281 = query.getOrDefault("$.xgafv")
  valid_594281 = validateParameter(valid_594281, JString, required = false,
                                 default = newJString("1"))
  if valid_594281 != nil:
    section.add "$.xgafv", valid_594281
  var valid_594282 = query.getOrDefault("prettyPrint")
  valid_594282 = validateParameter(valid_594282, JBool, required = false,
                                 default = newJBool(true))
  if valid_594282 != nil:
    section.add "prettyPrint", valid_594282
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

proc call*(call_594284: Call_LoggingBillingAccountsSinksCreate_594267;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a sink that exports specified log entries to a destination. The export of newly-ingested log entries begins immediately, unless the sink's writer_identity is not permitted to write to the destination. A sink can export log entries only from the resource owning the sink.
  ## 
  let valid = call_594284.validator(path, query, header, formData, body)
  let scheme = call_594284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594284.url(scheme.get, call_594284.host, call_594284.base,
                         call_594284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594284, url, valid)

proc call*(call_594285: Call_LoggingBillingAccountsSinksCreate_594267;
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
  var path_594286 = newJObject()
  var query_594287 = newJObject()
  var body_594288 = newJObject()
  add(query_594287, "upload_protocol", newJString(uploadProtocol))
  add(query_594287, "fields", newJString(fields))
  add(query_594287, "quotaUser", newJString(quotaUser))
  add(query_594287, "alt", newJString(alt))
  add(query_594287, "uniqueWriterIdentity", newJBool(uniqueWriterIdentity))
  add(query_594287, "oauth_token", newJString(oauthToken))
  add(query_594287, "callback", newJString(callback))
  add(query_594287, "access_token", newJString(accessToken))
  add(query_594287, "uploadType", newJString(uploadType))
  add(path_594286, "parent", newJString(parent))
  add(query_594287, "key", newJString(key))
  add(query_594287, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594288 = body
  add(query_594287, "prettyPrint", newJBool(prettyPrint))
  result = call_594285.call(path_594286, query_594287, nil, nil, body_594288)

var loggingBillingAccountsSinksCreate* = Call_LoggingBillingAccountsSinksCreate_594267(
    name: "loggingBillingAccountsSinksCreate", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2/{parent}/sinks",
    validator: validate_LoggingBillingAccountsSinksCreate_594268, base: "/",
    url: url_LoggingBillingAccountsSinksCreate_594269, schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsSinksList_594246 = ref object of OpenApiRestCall_593408
proc url_LoggingBillingAccountsSinksList_594248(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_LoggingBillingAccountsSinksList_594247(path: JsonNode;
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
  var valid_594249 = path.getOrDefault("parent")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "parent", valid_594249
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
  var valid_594250 = query.getOrDefault("upload_protocol")
  valid_594250 = validateParameter(valid_594250, JString, required = false,
                                 default = nil)
  if valid_594250 != nil:
    section.add "upload_protocol", valid_594250
  var valid_594251 = query.getOrDefault("fields")
  valid_594251 = validateParameter(valid_594251, JString, required = false,
                                 default = nil)
  if valid_594251 != nil:
    section.add "fields", valid_594251
  var valid_594252 = query.getOrDefault("pageToken")
  valid_594252 = validateParameter(valid_594252, JString, required = false,
                                 default = nil)
  if valid_594252 != nil:
    section.add "pageToken", valid_594252
  var valid_594253 = query.getOrDefault("quotaUser")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = nil)
  if valid_594253 != nil:
    section.add "quotaUser", valid_594253
  var valid_594254 = query.getOrDefault("alt")
  valid_594254 = validateParameter(valid_594254, JString, required = false,
                                 default = newJString("json"))
  if valid_594254 != nil:
    section.add "alt", valid_594254
  var valid_594255 = query.getOrDefault("oauth_token")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = nil)
  if valid_594255 != nil:
    section.add "oauth_token", valid_594255
  var valid_594256 = query.getOrDefault("callback")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "callback", valid_594256
  var valid_594257 = query.getOrDefault("access_token")
  valid_594257 = validateParameter(valid_594257, JString, required = false,
                                 default = nil)
  if valid_594257 != nil:
    section.add "access_token", valid_594257
  var valid_594258 = query.getOrDefault("uploadType")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = nil)
  if valid_594258 != nil:
    section.add "uploadType", valid_594258
  var valid_594259 = query.getOrDefault("key")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "key", valid_594259
  var valid_594260 = query.getOrDefault("$.xgafv")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = newJString("1"))
  if valid_594260 != nil:
    section.add "$.xgafv", valid_594260
  var valid_594261 = query.getOrDefault("pageSize")
  valid_594261 = validateParameter(valid_594261, JInt, required = false, default = nil)
  if valid_594261 != nil:
    section.add "pageSize", valid_594261
  var valid_594262 = query.getOrDefault("prettyPrint")
  valid_594262 = validateParameter(valid_594262, JBool, required = false,
                                 default = newJBool(true))
  if valid_594262 != nil:
    section.add "prettyPrint", valid_594262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594263: Call_LoggingBillingAccountsSinksList_594246;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists sinks.
  ## 
  let valid = call_594263.validator(path, query, header, formData, body)
  let scheme = call_594263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594263.url(scheme.get, call_594263.host, call_594263.base,
                         call_594263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594263, url, valid)

proc call*(call_594264: Call_LoggingBillingAccountsSinksList_594246;
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
  var path_594265 = newJObject()
  var query_594266 = newJObject()
  add(query_594266, "upload_protocol", newJString(uploadProtocol))
  add(query_594266, "fields", newJString(fields))
  add(query_594266, "pageToken", newJString(pageToken))
  add(query_594266, "quotaUser", newJString(quotaUser))
  add(query_594266, "alt", newJString(alt))
  add(query_594266, "oauth_token", newJString(oauthToken))
  add(query_594266, "callback", newJString(callback))
  add(query_594266, "access_token", newJString(accessToken))
  add(query_594266, "uploadType", newJString(uploadType))
  add(path_594265, "parent", newJString(parent))
  add(query_594266, "key", newJString(key))
  add(query_594266, "$.xgafv", newJString(Xgafv))
  add(query_594266, "pageSize", newJInt(pageSize))
  add(query_594266, "prettyPrint", newJBool(prettyPrint))
  result = call_594264.call(path_594265, query_594266, nil, nil, nil)

var loggingBillingAccountsSinksList* = Call_LoggingBillingAccountsSinksList_594246(
    name: "loggingBillingAccountsSinksList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{parent}/sinks",
    validator: validate_LoggingBillingAccountsSinksList_594247, base: "/",
    url: url_LoggingBillingAccountsSinksList_594248, schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsSinksUpdate_594308 = ref object of OpenApiRestCall_593408
proc url_LoggingBillingAccountsSinksUpdate_594310(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "sinkName" in path, "`sinkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "sinkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingBillingAccountsSinksUpdate_594309(path: JsonNode;
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
  var valid_594311 = path.getOrDefault("sinkName")
  valid_594311 = validateParameter(valid_594311, JString, required = true,
                                 default = nil)
  if valid_594311 != nil:
    section.add "sinkName", valid_594311
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
  var valid_594312 = query.getOrDefault("upload_protocol")
  valid_594312 = validateParameter(valid_594312, JString, required = false,
                                 default = nil)
  if valid_594312 != nil:
    section.add "upload_protocol", valid_594312
  var valid_594313 = query.getOrDefault("fields")
  valid_594313 = validateParameter(valid_594313, JString, required = false,
                                 default = nil)
  if valid_594313 != nil:
    section.add "fields", valid_594313
  var valid_594314 = query.getOrDefault("quotaUser")
  valid_594314 = validateParameter(valid_594314, JString, required = false,
                                 default = nil)
  if valid_594314 != nil:
    section.add "quotaUser", valid_594314
  var valid_594315 = query.getOrDefault("alt")
  valid_594315 = validateParameter(valid_594315, JString, required = false,
                                 default = newJString("json"))
  if valid_594315 != nil:
    section.add "alt", valid_594315
  var valid_594316 = query.getOrDefault("uniqueWriterIdentity")
  valid_594316 = validateParameter(valid_594316, JBool, required = false, default = nil)
  if valid_594316 != nil:
    section.add "uniqueWriterIdentity", valid_594316
  var valid_594317 = query.getOrDefault("oauth_token")
  valid_594317 = validateParameter(valid_594317, JString, required = false,
                                 default = nil)
  if valid_594317 != nil:
    section.add "oauth_token", valid_594317
  var valid_594318 = query.getOrDefault("callback")
  valid_594318 = validateParameter(valid_594318, JString, required = false,
                                 default = nil)
  if valid_594318 != nil:
    section.add "callback", valid_594318
  var valid_594319 = query.getOrDefault("access_token")
  valid_594319 = validateParameter(valid_594319, JString, required = false,
                                 default = nil)
  if valid_594319 != nil:
    section.add "access_token", valid_594319
  var valid_594320 = query.getOrDefault("uploadType")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = nil)
  if valid_594320 != nil:
    section.add "uploadType", valid_594320
  var valid_594321 = query.getOrDefault("key")
  valid_594321 = validateParameter(valid_594321, JString, required = false,
                                 default = nil)
  if valid_594321 != nil:
    section.add "key", valid_594321
  var valid_594322 = query.getOrDefault("$.xgafv")
  valid_594322 = validateParameter(valid_594322, JString, required = false,
                                 default = newJString("1"))
  if valid_594322 != nil:
    section.add "$.xgafv", valid_594322
  var valid_594323 = query.getOrDefault("prettyPrint")
  valid_594323 = validateParameter(valid_594323, JBool, required = false,
                                 default = newJBool(true))
  if valid_594323 != nil:
    section.add "prettyPrint", valid_594323
  var valid_594324 = query.getOrDefault("updateMask")
  valid_594324 = validateParameter(valid_594324, JString, required = false,
                                 default = nil)
  if valid_594324 != nil:
    section.add "updateMask", valid_594324
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

proc call*(call_594326: Call_LoggingBillingAccountsSinksUpdate_594308;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a sink. This method replaces the following fields in the existing sink with values from the new sink: destination, and filter.The updated sink might also have a new writer_identity; see the unique_writer_identity field.
  ## 
  let valid = call_594326.validator(path, query, header, formData, body)
  let scheme = call_594326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594326.url(scheme.get, call_594326.host, call_594326.base,
                         call_594326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594326, url, valid)

proc call*(call_594327: Call_LoggingBillingAccountsSinksUpdate_594308;
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
  var path_594328 = newJObject()
  var query_594329 = newJObject()
  var body_594330 = newJObject()
  add(query_594329, "upload_protocol", newJString(uploadProtocol))
  add(query_594329, "fields", newJString(fields))
  add(query_594329, "quotaUser", newJString(quotaUser))
  add(path_594328, "sinkName", newJString(sinkName))
  add(query_594329, "alt", newJString(alt))
  add(query_594329, "uniqueWriterIdentity", newJBool(uniqueWriterIdentity))
  add(query_594329, "oauth_token", newJString(oauthToken))
  add(query_594329, "callback", newJString(callback))
  add(query_594329, "access_token", newJString(accessToken))
  add(query_594329, "uploadType", newJString(uploadType))
  add(query_594329, "key", newJString(key))
  add(query_594329, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594330 = body
  add(query_594329, "prettyPrint", newJBool(prettyPrint))
  add(query_594329, "updateMask", newJString(updateMask))
  result = call_594327.call(path_594328, query_594329, nil, nil, body_594330)

var loggingBillingAccountsSinksUpdate* = Call_LoggingBillingAccountsSinksUpdate_594308(
    name: "loggingBillingAccountsSinksUpdate", meth: HttpMethod.HttpPut,
    host: "logging.googleapis.com", route: "/v2/{sinkName}",
    validator: validate_LoggingBillingAccountsSinksUpdate_594309, base: "/",
    url: url_LoggingBillingAccountsSinksUpdate_594310, schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsSinksGet_594289 = ref object of OpenApiRestCall_593408
proc url_LoggingBillingAccountsSinksGet_594291(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "sinkName" in path, "`sinkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "sinkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingBillingAccountsSinksGet_594290(path: JsonNode;
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
  var valid_594292 = path.getOrDefault("sinkName")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "sinkName", valid_594292
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
  var valid_594293 = query.getOrDefault("upload_protocol")
  valid_594293 = validateParameter(valid_594293, JString, required = false,
                                 default = nil)
  if valid_594293 != nil:
    section.add "upload_protocol", valid_594293
  var valid_594294 = query.getOrDefault("fields")
  valid_594294 = validateParameter(valid_594294, JString, required = false,
                                 default = nil)
  if valid_594294 != nil:
    section.add "fields", valid_594294
  var valid_594295 = query.getOrDefault("quotaUser")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = nil)
  if valid_594295 != nil:
    section.add "quotaUser", valid_594295
  var valid_594296 = query.getOrDefault("alt")
  valid_594296 = validateParameter(valid_594296, JString, required = false,
                                 default = newJString("json"))
  if valid_594296 != nil:
    section.add "alt", valid_594296
  var valid_594297 = query.getOrDefault("oauth_token")
  valid_594297 = validateParameter(valid_594297, JString, required = false,
                                 default = nil)
  if valid_594297 != nil:
    section.add "oauth_token", valid_594297
  var valid_594298 = query.getOrDefault("callback")
  valid_594298 = validateParameter(valid_594298, JString, required = false,
                                 default = nil)
  if valid_594298 != nil:
    section.add "callback", valid_594298
  var valid_594299 = query.getOrDefault("access_token")
  valid_594299 = validateParameter(valid_594299, JString, required = false,
                                 default = nil)
  if valid_594299 != nil:
    section.add "access_token", valid_594299
  var valid_594300 = query.getOrDefault("uploadType")
  valid_594300 = validateParameter(valid_594300, JString, required = false,
                                 default = nil)
  if valid_594300 != nil:
    section.add "uploadType", valid_594300
  var valid_594301 = query.getOrDefault("key")
  valid_594301 = validateParameter(valid_594301, JString, required = false,
                                 default = nil)
  if valid_594301 != nil:
    section.add "key", valid_594301
  var valid_594302 = query.getOrDefault("$.xgafv")
  valid_594302 = validateParameter(valid_594302, JString, required = false,
                                 default = newJString("1"))
  if valid_594302 != nil:
    section.add "$.xgafv", valid_594302
  var valid_594303 = query.getOrDefault("prettyPrint")
  valid_594303 = validateParameter(valid_594303, JBool, required = false,
                                 default = newJBool(true))
  if valid_594303 != nil:
    section.add "prettyPrint", valid_594303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594304: Call_LoggingBillingAccountsSinksGet_594289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a sink.
  ## 
  let valid = call_594304.validator(path, query, header, formData, body)
  let scheme = call_594304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594304.url(scheme.get, call_594304.host, call_594304.base,
                         call_594304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594304, url, valid)

proc call*(call_594305: Call_LoggingBillingAccountsSinksGet_594289;
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
  var path_594306 = newJObject()
  var query_594307 = newJObject()
  add(query_594307, "upload_protocol", newJString(uploadProtocol))
  add(query_594307, "fields", newJString(fields))
  add(query_594307, "quotaUser", newJString(quotaUser))
  add(path_594306, "sinkName", newJString(sinkName))
  add(query_594307, "alt", newJString(alt))
  add(query_594307, "oauth_token", newJString(oauthToken))
  add(query_594307, "callback", newJString(callback))
  add(query_594307, "access_token", newJString(accessToken))
  add(query_594307, "uploadType", newJString(uploadType))
  add(query_594307, "key", newJString(key))
  add(query_594307, "$.xgafv", newJString(Xgafv))
  add(query_594307, "prettyPrint", newJBool(prettyPrint))
  result = call_594305.call(path_594306, query_594307, nil, nil, nil)

var loggingBillingAccountsSinksGet* = Call_LoggingBillingAccountsSinksGet_594289(
    name: "loggingBillingAccountsSinksGet", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{sinkName}",
    validator: validate_LoggingBillingAccountsSinksGet_594290, base: "/",
    url: url_LoggingBillingAccountsSinksGet_594291, schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsSinksPatch_594350 = ref object of OpenApiRestCall_593408
proc url_LoggingBillingAccountsSinksPatch_594352(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "sinkName" in path, "`sinkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "sinkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingBillingAccountsSinksPatch_594351(path: JsonNode;
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
  var valid_594353 = path.getOrDefault("sinkName")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = nil)
  if valid_594353 != nil:
    section.add "sinkName", valid_594353
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
  var valid_594354 = query.getOrDefault("upload_protocol")
  valid_594354 = validateParameter(valid_594354, JString, required = false,
                                 default = nil)
  if valid_594354 != nil:
    section.add "upload_protocol", valid_594354
  var valid_594355 = query.getOrDefault("fields")
  valid_594355 = validateParameter(valid_594355, JString, required = false,
                                 default = nil)
  if valid_594355 != nil:
    section.add "fields", valid_594355
  var valid_594356 = query.getOrDefault("quotaUser")
  valid_594356 = validateParameter(valid_594356, JString, required = false,
                                 default = nil)
  if valid_594356 != nil:
    section.add "quotaUser", valid_594356
  var valid_594357 = query.getOrDefault("alt")
  valid_594357 = validateParameter(valid_594357, JString, required = false,
                                 default = newJString("json"))
  if valid_594357 != nil:
    section.add "alt", valid_594357
  var valid_594358 = query.getOrDefault("uniqueWriterIdentity")
  valid_594358 = validateParameter(valid_594358, JBool, required = false, default = nil)
  if valid_594358 != nil:
    section.add "uniqueWriterIdentity", valid_594358
  var valid_594359 = query.getOrDefault("oauth_token")
  valid_594359 = validateParameter(valid_594359, JString, required = false,
                                 default = nil)
  if valid_594359 != nil:
    section.add "oauth_token", valid_594359
  var valid_594360 = query.getOrDefault("callback")
  valid_594360 = validateParameter(valid_594360, JString, required = false,
                                 default = nil)
  if valid_594360 != nil:
    section.add "callback", valid_594360
  var valid_594361 = query.getOrDefault("access_token")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = nil)
  if valid_594361 != nil:
    section.add "access_token", valid_594361
  var valid_594362 = query.getOrDefault("uploadType")
  valid_594362 = validateParameter(valid_594362, JString, required = false,
                                 default = nil)
  if valid_594362 != nil:
    section.add "uploadType", valid_594362
  var valid_594363 = query.getOrDefault("key")
  valid_594363 = validateParameter(valid_594363, JString, required = false,
                                 default = nil)
  if valid_594363 != nil:
    section.add "key", valid_594363
  var valid_594364 = query.getOrDefault("$.xgafv")
  valid_594364 = validateParameter(valid_594364, JString, required = false,
                                 default = newJString("1"))
  if valid_594364 != nil:
    section.add "$.xgafv", valid_594364
  var valid_594365 = query.getOrDefault("prettyPrint")
  valid_594365 = validateParameter(valid_594365, JBool, required = false,
                                 default = newJBool(true))
  if valid_594365 != nil:
    section.add "prettyPrint", valid_594365
  var valid_594366 = query.getOrDefault("updateMask")
  valid_594366 = validateParameter(valid_594366, JString, required = false,
                                 default = nil)
  if valid_594366 != nil:
    section.add "updateMask", valid_594366
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

proc call*(call_594368: Call_LoggingBillingAccountsSinksPatch_594350;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a sink. This method replaces the following fields in the existing sink with values from the new sink: destination, and filter.The updated sink might also have a new writer_identity; see the unique_writer_identity field.
  ## 
  let valid = call_594368.validator(path, query, header, formData, body)
  let scheme = call_594368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594368.url(scheme.get, call_594368.host, call_594368.base,
                         call_594368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594368, url, valid)

proc call*(call_594369: Call_LoggingBillingAccountsSinksPatch_594350;
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
  var path_594370 = newJObject()
  var query_594371 = newJObject()
  var body_594372 = newJObject()
  add(query_594371, "upload_protocol", newJString(uploadProtocol))
  add(query_594371, "fields", newJString(fields))
  add(query_594371, "quotaUser", newJString(quotaUser))
  add(path_594370, "sinkName", newJString(sinkName))
  add(query_594371, "alt", newJString(alt))
  add(query_594371, "uniqueWriterIdentity", newJBool(uniqueWriterIdentity))
  add(query_594371, "oauth_token", newJString(oauthToken))
  add(query_594371, "callback", newJString(callback))
  add(query_594371, "access_token", newJString(accessToken))
  add(query_594371, "uploadType", newJString(uploadType))
  add(query_594371, "key", newJString(key))
  add(query_594371, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594372 = body
  add(query_594371, "prettyPrint", newJBool(prettyPrint))
  add(query_594371, "updateMask", newJString(updateMask))
  result = call_594369.call(path_594370, query_594371, nil, nil, body_594372)

var loggingBillingAccountsSinksPatch* = Call_LoggingBillingAccountsSinksPatch_594350(
    name: "loggingBillingAccountsSinksPatch", meth: HttpMethod.HttpPatch,
    host: "logging.googleapis.com", route: "/v2/{sinkName}",
    validator: validate_LoggingBillingAccountsSinksPatch_594351, base: "/",
    url: url_LoggingBillingAccountsSinksPatch_594352, schemes: {Scheme.Https})
type
  Call_LoggingBillingAccountsSinksDelete_594331 = ref object of OpenApiRestCall_593408
proc url_LoggingBillingAccountsSinksDelete_594333(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "sinkName" in path, "`sinkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "sinkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingBillingAccountsSinksDelete_594332(path: JsonNode;
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
  var valid_594334 = path.getOrDefault("sinkName")
  valid_594334 = validateParameter(valid_594334, JString, required = true,
                                 default = nil)
  if valid_594334 != nil:
    section.add "sinkName", valid_594334
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
  var valid_594335 = query.getOrDefault("upload_protocol")
  valid_594335 = validateParameter(valid_594335, JString, required = false,
                                 default = nil)
  if valid_594335 != nil:
    section.add "upload_protocol", valid_594335
  var valid_594336 = query.getOrDefault("fields")
  valid_594336 = validateParameter(valid_594336, JString, required = false,
                                 default = nil)
  if valid_594336 != nil:
    section.add "fields", valid_594336
  var valid_594337 = query.getOrDefault("quotaUser")
  valid_594337 = validateParameter(valid_594337, JString, required = false,
                                 default = nil)
  if valid_594337 != nil:
    section.add "quotaUser", valid_594337
  var valid_594338 = query.getOrDefault("alt")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = newJString("json"))
  if valid_594338 != nil:
    section.add "alt", valid_594338
  var valid_594339 = query.getOrDefault("oauth_token")
  valid_594339 = validateParameter(valid_594339, JString, required = false,
                                 default = nil)
  if valid_594339 != nil:
    section.add "oauth_token", valid_594339
  var valid_594340 = query.getOrDefault("callback")
  valid_594340 = validateParameter(valid_594340, JString, required = false,
                                 default = nil)
  if valid_594340 != nil:
    section.add "callback", valid_594340
  var valid_594341 = query.getOrDefault("access_token")
  valid_594341 = validateParameter(valid_594341, JString, required = false,
                                 default = nil)
  if valid_594341 != nil:
    section.add "access_token", valid_594341
  var valid_594342 = query.getOrDefault("uploadType")
  valid_594342 = validateParameter(valid_594342, JString, required = false,
                                 default = nil)
  if valid_594342 != nil:
    section.add "uploadType", valid_594342
  var valid_594343 = query.getOrDefault("key")
  valid_594343 = validateParameter(valid_594343, JString, required = false,
                                 default = nil)
  if valid_594343 != nil:
    section.add "key", valid_594343
  var valid_594344 = query.getOrDefault("$.xgafv")
  valid_594344 = validateParameter(valid_594344, JString, required = false,
                                 default = newJString("1"))
  if valid_594344 != nil:
    section.add "$.xgafv", valid_594344
  var valid_594345 = query.getOrDefault("prettyPrint")
  valid_594345 = validateParameter(valid_594345, JBool, required = false,
                                 default = newJBool(true))
  if valid_594345 != nil:
    section.add "prettyPrint", valid_594345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594346: Call_LoggingBillingAccountsSinksDelete_594331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a sink. If the sink has a unique writer_identity, then that service account is also deleted.
  ## 
  let valid = call_594346.validator(path, query, header, formData, body)
  let scheme = call_594346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594346.url(scheme.get, call_594346.host, call_594346.base,
                         call_594346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594346, url, valid)

proc call*(call_594347: Call_LoggingBillingAccountsSinksDelete_594331;
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
  var path_594348 = newJObject()
  var query_594349 = newJObject()
  add(query_594349, "upload_protocol", newJString(uploadProtocol))
  add(query_594349, "fields", newJString(fields))
  add(query_594349, "quotaUser", newJString(quotaUser))
  add(path_594348, "sinkName", newJString(sinkName))
  add(query_594349, "alt", newJString(alt))
  add(query_594349, "oauth_token", newJString(oauthToken))
  add(query_594349, "callback", newJString(callback))
  add(query_594349, "access_token", newJString(accessToken))
  add(query_594349, "uploadType", newJString(uploadType))
  add(query_594349, "key", newJString(key))
  add(query_594349, "$.xgafv", newJString(Xgafv))
  add(query_594349, "prettyPrint", newJBool(prettyPrint))
  result = call_594347.call(path_594348, query_594349, nil, nil, nil)

var loggingBillingAccountsSinksDelete* = Call_LoggingBillingAccountsSinksDelete_594331(
    name: "loggingBillingAccountsSinksDelete", meth: HttpMethod.HttpDelete,
    host: "logging.googleapis.com", route: "/v2/{sinkName}",
    validator: validate_LoggingBillingAccountsSinksDelete_594332, base: "/",
    url: url_LoggingBillingAccountsSinksDelete_594333, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
