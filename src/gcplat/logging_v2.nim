
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  Call_LoggingEntriesList_588710 = ref object of OpenApiRestCall_588441
proc url_LoggingEntriesList_588712(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_LoggingEntriesList_588711(path: JsonNode; query: JsonNode;
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
  var valid_588824 = query.getOrDefault("upload_protocol")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "upload_protocol", valid_588824
  var valid_588825 = query.getOrDefault("fields")
  valid_588825 = validateParameter(valid_588825, JString, required = false,
                                 default = nil)
  if valid_588825 != nil:
    section.add "fields", valid_588825
  var valid_588826 = query.getOrDefault("quotaUser")
  valid_588826 = validateParameter(valid_588826, JString, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "quotaUser", valid_588826
  var valid_588840 = query.getOrDefault("alt")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = newJString("json"))
  if valid_588840 != nil:
    section.add "alt", valid_588840
  var valid_588841 = query.getOrDefault("oauth_token")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "oauth_token", valid_588841
  var valid_588842 = query.getOrDefault("callback")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "callback", valid_588842
  var valid_588843 = query.getOrDefault("access_token")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "access_token", valid_588843
  var valid_588844 = query.getOrDefault("uploadType")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "uploadType", valid_588844
  var valid_588845 = query.getOrDefault("key")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "key", valid_588845
  var valid_588846 = query.getOrDefault("$.xgafv")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = newJString("1"))
  if valid_588846 != nil:
    section.add "$.xgafv", valid_588846
  var valid_588847 = query.getOrDefault("prettyPrint")
  valid_588847 = validateParameter(valid_588847, JBool, required = false,
                                 default = newJBool(true))
  if valid_588847 != nil:
    section.add "prettyPrint", valid_588847
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

proc call*(call_588871: Call_LoggingEntriesList_588710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists log entries. Use this method to retrieve log entries that originated from a project/folder/organization/billing account. For ways to export log entries, see Exporting Logs.
  ## 
  let valid = call_588871.validator(path, query, header, formData, body)
  let scheme = call_588871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588871.url(scheme.get, call_588871.host, call_588871.base,
                         call_588871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588871, url, valid)

proc call*(call_588942: Call_LoggingEntriesList_588710;
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
  var query_588943 = newJObject()
  var body_588945 = newJObject()
  add(query_588943, "upload_protocol", newJString(uploadProtocol))
  add(query_588943, "fields", newJString(fields))
  add(query_588943, "quotaUser", newJString(quotaUser))
  add(query_588943, "alt", newJString(alt))
  add(query_588943, "oauth_token", newJString(oauthToken))
  add(query_588943, "callback", newJString(callback))
  add(query_588943, "access_token", newJString(accessToken))
  add(query_588943, "uploadType", newJString(uploadType))
  add(query_588943, "key", newJString(key))
  add(query_588943, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_588945 = body
  add(query_588943, "prettyPrint", newJBool(prettyPrint))
  result = call_588942.call(nil, query_588943, nil, nil, body_588945)

var loggingEntriesList* = Call_LoggingEntriesList_588710(
    name: "loggingEntriesList", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2/entries:list",
    validator: validate_LoggingEntriesList_588711, base: "/",
    url: url_LoggingEntriesList_588712, schemes: {Scheme.Https})
type
  Call_LoggingEntriesWrite_588984 = ref object of OpenApiRestCall_588441
proc url_LoggingEntriesWrite_588986(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_LoggingEntriesWrite_588985(path: JsonNode; query: JsonNode;
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
  var valid_588987 = query.getOrDefault("upload_protocol")
  valid_588987 = validateParameter(valid_588987, JString, required = false,
                                 default = nil)
  if valid_588987 != nil:
    section.add "upload_protocol", valid_588987
  var valid_588988 = query.getOrDefault("fields")
  valid_588988 = validateParameter(valid_588988, JString, required = false,
                                 default = nil)
  if valid_588988 != nil:
    section.add "fields", valid_588988
  var valid_588989 = query.getOrDefault("quotaUser")
  valid_588989 = validateParameter(valid_588989, JString, required = false,
                                 default = nil)
  if valid_588989 != nil:
    section.add "quotaUser", valid_588989
  var valid_588990 = query.getOrDefault("alt")
  valid_588990 = validateParameter(valid_588990, JString, required = false,
                                 default = newJString("json"))
  if valid_588990 != nil:
    section.add "alt", valid_588990
  var valid_588991 = query.getOrDefault("oauth_token")
  valid_588991 = validateParameter(valid_588991, JString, required = false,
                                 default = nil)
  if valid_588991 != nil:
    section.add "oauth_token", valid_588991
  var valid_588992 = query.getOrDefault("callback")
  valid_588992 = validateParameter(valid_588992, JString, required = false,
                                 default = nil)
  if valid_588992 != nil:
    section.add "callback", valid_588992
  var valid_588993 = query.getOrDefault("access_token")
  valid_588993 = validateParameter(valid_588993, JString, required = false,
                                 default = nil)
  if valid_588993 != nil:
    section.add "access_token", valid_588993
  var valid_588994 = query.getOrDefault("uploadType")
  valid_588994 = validateParameter(valid_588994, JString, required = false,
                                 default = nil)
  if valid_588994 != nil:
    section.add "uploadType", valid_588994
  var valid_588995 = query.getOrDefault("key")
  valid_588995 = validateParameter(valid_588995, JString, required = false,
                                 default = nil)
  if valid_588995 != nil:
    section.add "key", valid_588995
  var valid_588996 = query.getOrDefault("$.xgafv")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = newJString("1"))
  if valid_588996 != nil:
    section.add "$.xgafv", valid_588996
  var valid_588997 = query.getOrDefault("prettyPrint")
  valid_588997 = validateParameter(valid_588997, JBool, required = false,
                                 default = newJBool(true))
  if valid_588997 != nil:
    section.add "prettyPrint", valid_588997
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

proc call*(call_588999: Call_LoggingEntriesWrite_588984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Writes log entries to Logging. This API method is the only way to send log entries to Logging. This method is used, directly or indirectly, by the Logging agent (fluentd) and all logging libraries configured to use Logging. A single request may contain log entries for a maximum of 1000 different resources (projects, organizations, billing accounts or folders)
  ## 
  let valid = call_588999.validator(path, query, header, formData, body)
  let scheme = call_588999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588999.url(scheme.get, call_588999.host, call_588999.base,
                         call_588999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588999, url, valid)

proc call*(call_589000: Call_LoggingEntriesWrite_588984;
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
  var query_589001 = newJObject()
  var body_589002 = newJObject()
  add(query_589001, "upload_protocol", newJString(uploadProtocol))
  add(query_589001, "fields", newJString(fields))
  add(query_589001, "quotaUser", newJString(quotaUser))
  add(query_589001, "alt", newJString(alt))
  add(query_589001, "oauth_token", newJString(oauthToken))
  add(query_589001, "callback", newJString(callback))
  add(query_589001, "access_token", newJString(accessToken))
  add(query_589001, "uploadType", newJString(uploadType))
  add(query_589001, "key", newJString(key))
  add(query_589001, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589002 = body
  add(query_589001, "prettyPrint", newJBool(prettyPrint))
  result = call_589000.call(nil, query_589001, nil, nil, body_589002)

var loggingEntriesWrite* = Call_LoggingEntriesWrite_588984(
    name: "loggingEntriesWrite", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2/entries:write",
    validator: validate_LoggingEntriesWrite_588985, base: "/",
    url: url_LoggingEntriesWrite_588986, schemes: {Scheme.Https})
type
  Call_LoggingMonitoredResourceDescriptorsList_589003 = ref object of OpenApiRestCall_588441
proc url_LoggingMonitoredResourceDescriptorsList_589005(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_LoggingMonitoredResourceDescriptorsList_589004(path: JsonNode;
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
  var valid_589006 = query.getOrDefault("upload_protocol")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "upload_protocol", valid_589006
  var valid_589007 = query.getOrDefault("fields")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "fields", valid_589007
  var valid_589008 = query.getOrDefault("pageToken")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "pageToken", valid_589008
  var valid_589009 = query.getOrDefault("quotaUser")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "quotaUser", valid_589009
  var valid_589010 = query.getOrDefault("alt")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = newJString("json"))
  if valid_589010 != nil:
    section.add "alt", valid_589010
  var valid_589011 = query.getOrDefault("oauth_token")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "oauth_token", valid_589011
  var valid_589012 = query.getOrDefault("callback")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "callback", valid_589012
  var valid_589013 = query.getOrDefault("access_token")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "access_token", valid_589013
  var valid_589014 = query.getOrDefault("uploadType")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "uploadType", valid_589014
  var valid_589015 = query.getOrDefault("key")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "key", valid_589015
  var valid_589016 = query.getOrDefault("$.xgafv")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = newJString("1"))
  if valid_589016 != nil:
    section.add "$.xgafv", valid_589016
  var valid_589017 = query.getOrDefault("pageSize")
  valid_589017 = validateParameter(valid_589017, JInt, required = false, default = nil)
  if valid_589017 != nil:
    section.add "pageSize", valid_589017
  var valid_589018 = query.getOrDefault("prettyPrint")
  valid_589018 = validateParameter(valid_589018, JBool, required = false,
                                 default = newJBool(true))
  if valid_589018 != nil:
    section.add "prettyPrint", valid_589018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589019: Call_LoggingMonitoredResourceDescriptorsList_589003;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the descriptors for monitored resource types used by Logging.
  ## 
  let valid = call_589019.validator(path, query, header, formData, body)
  let scheme = call_589019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589019.url(scheme.get, call_589019.host, call_589019.base,
                         call_589019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589019, url, valid)

proc call*(call_589020: Call_LoggingMonitoredResourceDescriptorsList_589003;
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
  var query_589021 = newJObject()
  add(query_589021, "upload_protocol", newJString(uploadProtocol))
  add(query_589021, "fields", newJString(fields))
  add(query_589021, "pageToken", newJString(pageToken))
  add(query_589021, "quotaUser", newJString(quotaUser))
  add(query_589021, "alt", newJString(alt))
  add(query_589021, "oauth_token", newJString(oauthToken))
  add(query_589021, "callback", newJString(callback))
  add(query_589021, "access_token", newJString(accessToken))
  add(query_589021, "uploadType", newJString(uploadType))
  add(query_589021, "key", newJString(key))
  add(query_589021, "$.xgafv", newJString(Xgafv))
  add(query_589021, "pageSize", newJInt(pageSize))
  add(query_589021, "prettyPrint", newJBool(prettyPrint))
  result = call_589020.call(nil, query_589021, nil, nil, nil)

var loggingMonitoredResourceDescriptorsList* = Call_LoggingMonitoredResourceDescriptorsList_589003(
    name: "loggingMonitoredResourceDescriptorsList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/monitoredResourceDescriptors",
    validator: validate_LoggingMonitoredResourceDescriptorsList_589004, base: "/",
    url: url_LoggingMonitoredResourceDescriptorsList_589005,
    schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsLogsDelete_589022 = ref object of OpenApiRestCall_588441
proc url_LoggingOrganizationsLogsDelete_589024(protocol: Scheme; host: string;
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

proc validate_LoggingOrganizationsLogsDelete_589023(path: JsonNode;
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
  var valid_589039 = path.getOrDefault("logName")
  valid_589039 = validateParameter(valid_589039, JString, required = true,
                                 default = nil)
  if valid_589039 != nil:
    section.add "logName", valid_589039
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
  var valid_589040 = query.getOrDefault("upload_protocol")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "upload_protocol", valid_589040
  var valid_589041 = query.getOrDefault("fields")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "fields", valid_589041
  var valid_589042 = query.getOrDefault("quotaUser")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "quotaUser", valid_589042
  var valid_589043 = query.getOrDefault("alt")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = newJString("json"))
  if valid_589043 != nil:
    section.add "alt", valid_589043
  var valid_589044 = query.getOrDefault("oauth_token")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "oauth_token", valid_589044
  var valid_589045 = query.getOrDefault("callback")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "callback", valid_589045
  var valid_589046 = query.getOrDefault("access_token")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "access_token", valid_589046
  var valid_589047 = query.getOrDefault("uploadType")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "uploadType", valid_589047
  var valid_589048 = query.getOrDefault("key")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "key", valid_589048
  var valid_589049 = query.getOrDefault("$.xgafv")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = newJString("1"))
  if valid_589049 != nil:
    section.add "$.xgafv", valid_589049
  var valid_589050 = query.getOrDefault("prettyPrint")
  valid_589050 = validateParameter(valid_589050, JBool, required = false,
                                 default = newJBool(true))
  if valid_589050 != nil:
    section.add "prettyPrint", valid_589050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589051: Call_LoggingOrganizationsLogsDelete_589022; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes all the log entries in a log. The log reappears if it receives new entries. Log entries written shortly before the delete operation might not be deleted.
  ## 
  let valid = call_589051.validator(path, query, header, formData, body)
  let scheme = call_589051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589051.url(scheme.get, call_589051.host, call_589051.base,
                         call_589051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589051, url, valid)

proc call*(call_589052: Call_LoggingOrganizationsLogsDelete_589022;
          logName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## loggingOrganizationsLogsDelete
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
  var path_589053 = newJObject()
  var query_589054 = newJObject()
  add(query_589054, "upload_protocol", newJString(uploadProtocol))
  add(query_589054, "fields", newJString(fields))
  add(query_589054, "quotaUser", newJString(quotaUser))
  add(query_589054, "alt", newJString(alt))
  add(query_589054, "oauth_token", newJString(oauthToken))
  add(query_589054, "callback", newJString(callback))
  add(query_589054, "access_token", newJString(accessToken))
  add(query_589054, "uploadType", newJString(uploadType))
  add(path_589053, "logName", newJString(logName))
  add(query_589054, "key", newJString(key))
  add(query_589054, "$.xgafv", newJString(Xgafv))
  add(query_589054, "prettyPrint", newJBool(prettyPrint))
  result = call_589052.call(path_589053, query_589054, nil, nil, nil)

var loggingOrganizationsLogsDelete* = Call_LoggingOrganizationsLogsDelete_589022(
    name: "loggingOrganizationsLogsDelete", meth: HttpMethod.HttpDelete,
    host: "logging.googleapis.com", route: "/v2/{logName}",
    validator: validate_LoggingOrganizationsLogsDelete_589023, base: "/",
    url: url_LoggingOrganizationsLogsDelete_589024, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsUpdate_589074 = ref object of OpenApiRestCall_588441
proc url_LoggingProjectsMetricsUpdate_589076(protocol: Scheme; host: string;
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

proc validate_LoggingProjectsMetricsUpdate_589075(path: JsonNode; query: JsonNode;
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
  var valid_589077 = path.getOrDefault("metricName")
  valid_589077 = validateParameter(valid_589077, JString, required = true,
                                 default = nil)
  if valid_589077 != nil:
    section.add "metricName", valid_589077
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
  var valid_589078 = query.getOrDefault("upload_protocol")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "upload_protocol", valid_589078
  var valid_589079 = query.getOrDefault("fields")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "fields", valid_589079
  var valid_589080 = query.getOrDefault("quotaUser")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "quotaUser", valid_589080
  var valid_589081 = query.getOrDefault("alt")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = newJString("json"))
  if valid_589081 != nil:
    section.add "alt", valid_589081
  var valid_589082 = query.getOrDefault("oauth_token")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "oauth_token", valid_589082
  var valid_589083 = query.getOrDefault("callback")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "callback", valid_589083
  var valid_589084 = query.getOrDefault("access_token")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "access_token", valid_589084
  var valid_589085 = query.getOrDefault("uploadType")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "uploadType", valid_589085
  var valid_589086 = query.getOrDefault("key")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "key", valid_589086
  var valid_589087 = query.getOrDefault("$.xgafv")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = newJString("1"))
  if valid_589087 != nil:
    section.add "$.xgafv", valid_589087
  var valid_589088 = query.getOrDefault("prettyPrint")
  valid_589088 = validateParameter(valid_589088, JBool, required = false,
                                 default = newJBool(true))
  if valid_589088 != nil:
    section.add "prettyPrint", valid_589088
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

proc call*(call_589090: Call_LoggingProjectsMetricsUpdate_589074; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a logs-based metric.
  ## 
  let valid = call_589090.validator(path, query, header, formData, body)
  let scheme = call_589090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589090.url(scheme.get, call_589090.host, call_589090.base,
                         call_589090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589090, url, valid)

proc call*(call_589091: Call_LoggingProjectsMetricsUpdate_589074;
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
  var path_589092 = newJObject()
  var query_589093 = newJObject()
  var body_589094 = newJObject()
  add(query_589093, "upload_protocol", newJString(uploadProtocol))
  add(query_589093, "fields", newJString(fields))
  add(query_589093, "quotaUser", newJString(quotaUser))
  add(query_589093, "alt", newJString(alt))
  add(query_589093, "oauth_token", newJString(oauthToken))
  add(query_589093, "callback", newJString(callback))
  add(query_589093, "access_token", newJString(accessToken))
  add(query_589093, "uploadType", newJString(uploadType))
  add(path_589092, "metricName", newJString(metricName))
  add(query_589093, "key", newJString(key))
  add(query_589093, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589094 = body
  add(query_589093, "prettyPrint", newJBool(prettyPrint))
  result = call_589091.call(path_589092, query_589093, nil, nil, body_589094)

var loggingProjectsMetricsUpdate* = Call_LoggingProjectsMetricsUpdate_589074(
    name: "loggingProjectsMetricsUpdate", meth: HttpMethod.HttpPut,
    host: "logging.googleapis.com", route: "/v2/{metricName}",
    validator: validate_LoggingProjectsMetricsUpdate_589075, base: "/",
    url: url_LoggingProjectsMetricsUpdate_589076, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsGet_589055 = ref object of OpenApiRestCall_588441
proc url_LoggingProjectsMetricsGet_589057(protocol: Scheme; host: string;
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

proc validate_LoggingProjectsMetricsGet_589056(path: JsonNode; query: JsonNode;
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
  var valid_589058 = path.getOrDefault("metricName")
  valid_589058 = validateParameter(valid_589058, JString, required = true,
                                 default = nil)
  if valid_589058 != nil:
    section.add "metricName", valid_589058
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
  var valid_589059 = query.getOrDefault("upload_protocol")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "upload_protocol", valid_589059
  var valid_589060 = query.getOrDefault("fields")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "fields", valid_589060
  var valid_589061 = query.getOrDefault("quotaUser")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "quotaUser", valid_589061
  var valid_589062 = query.getOrDefault("alt")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = newJString("json"))
  if valid_589062 != nil:
    section.add "alt", valid_589062
  var valid_589063 = query.getOrDefault("oauth_token")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "oauth_token", valid_589063
  var valid_589064 = query.getOrDefault("callback")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "callback", valid_589064
  var valid_589065 = query.getOrDefault("access_token")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "access_token", valid_589065
  var valid_589066 = query.getOrDefault("uploadType")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "uploadType", valid_589066
  var valid_589067 = query.getOrDefault("key")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "key", valid_589067
  var valid_589068 = query.getOrDefault("$.xgafv")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = newJString("1"))
  if valid_589068 != nil:
    section.add "$.xgafv", valid_589068
  var valid_589069 = query.getOrDefault("prettyPrint")
  valid_589069 = validateParameter(valid_589069, JBool, required = false,
                                 default = newJBool(true))
  if valid_589069 != nil:
    section.add "prettyPrint", valid_589069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589070: Call_LoggingProjectsMetricsGet_589055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a logs-based metric.
  ## 
  let valid = call_589070.validator(path, query, header, formData, body)
  let scheme = call_589070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589070.url(scheme.get, call_589070.host, call_589070.base,
                         call_589070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589070, url, valid)

proc call*(call_589071: Call_LoggingProjectsMetricsGet_589055; metricName: string;
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
  var path_589072 = newJObject()
  var query_589073 = newJObject()
  add(query_589073, "upload_protocol", newJString(uploadProtocol))
  add(query_589073, "fields", newJString(fields))
  add(query_589073, "quotaUser", newJString(quotaUser))
  add(query_589073, "alt", newJString(alt))
  add(query_589073, "oauth_token", newJString(oauthToken))
  add(query_589073, "callback", newJString(callback))
  add(query_589073, "access_token", newJString(accessToken))
  add(query_589073, "uploadType", newJString(uploadType))
  add(path_589072, "metricName", newJString(metricName))
  add(query_589073, "key", newJString(key))
  add(query_589073, "$.xgafv", newJString(Xgafv))
  add(query_589073, "prettyPrint", newJBool(prettyPrint))
  result = call_589071.call(path_589072, query_589073, nil, nil, nil)

var loggingProjectsMetricsGet* = Call_LoggingProjectsMetricsGet_589055(
    name: "loggingProjectsMetricsGet", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{metricName}",
    validator: validate_LoggingProjectsMetricsGet_589056, base: "/",
    url: url_LoggingProjectsMetricsGet_589057, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsDelete_589095 = ref object of OpenApiRestCall_588441
proc url_LoggingProjectsMetricsDelete_589097(protocol: Scheme; host: string;
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

proc validate_LoggingProjectsMetricsDelete_589096(path: JsonNode; query: JsonNode;
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
  var valid_589098 = path.getOrDefault("metricName")
  valid_589098 = validateParameter(valid_589098, JString, required = true,
                                 default = nil)
  if valid_589098 != nil:
    section.add "metricName", valid_589098
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
  var valid_589099 = query.getOrDefault("upload_protocol")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "upload_protocol", valid_589099
  var valid_589100 = query.getOrDefault("fields")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "fields", valid_589100
  var valid_589101 = query.getOrDefault("quotaUser")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "quotaUser", valid_589101
  var valid_589102 = query.getOrDefault("alt")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = newJString("json"))
  if valid_589102 != nil:
    section.add "alt", valid_589102
  var valid_589103 = query.getOrDefault("oauth_token")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "oauth_token", valid_589103
  var valid_589104 = query.getOrDefault("callback")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "callback", valid_589104
  var valid_589105 = query.getOrDefault("access_token")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "access_token", valid_589105
  var valid_589106 = query.getOrDefault("uploadType")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "uploadType", valid_589106
  var valid_589107 = query.getOrDefault("key")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "key", valid_589107
  var valid_589108 = query.getOrDefault("$.xgafv")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = newJString("1"))
  if valid_589108 != nil:
    section.add "$.xgafv", valid_589108
  var valid_589109 = query.getOrDefault("prettyPrint")
  valid_589109 = validateParameter(valid_589109, JBool, required = false,
                                 default = newJBool(true))
  if valid_589109 != nil:
    section.add "prettyPrint", valid_589109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589110: Call_LoggingProjectsMetricsDelete_589095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a logs-based metric.
  ## 
  let valid = call_589110.validator(path, query, header, formData, body)
  let scheme = call_589110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589110.url(scheme.get, call_589110.host, call_589110.base,
                         call_589110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589110, url, valid)

proc call*(call_589111: Call_LoggingProjectsMetricsDelete_589095;
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
  var path_589112 = newJObject()
  var query_589113 = newJObject()
  add(query_589113, "upload_protocol", newJString(uploadProtocol))
  add(query_589113, "fields", newJString(fields))
  add(query_589113, "quotaUser", newJString(quotaUser))
  add(query_589113, "alt", newJString(alt))
  add(query_589113, "oauth_token", newJString(oauthToken))
  add(query_589113, "callback", newJString(callback))
  add(query_589113, "access_token", newJString(accessToken))
  add(query_589113, "uploadType", newJString(uploadType))
  add(path_589112, "metricName", newJString(metricName))
  add(query_589113, "key", newJString(key))
  add(query_589113, "$.xgafv", newJString(Xgafv))
  add(query_589113, "prettyPrint", newJBool(prettyPrint))
  result = call_589111.call(path_589112, query_589113, nil, nil, nil)

var loggingProjectsMetricsDelete* = Call_LoggingProjectsMetricsDelete_589095(
    name: "loggingProjectsMetricsDelete", meth: HttpMethod.HttpDelete,
    host: "logging.googleapis.com", route: "/v2/{metricName}",
    validator: validate_LoggingProjectsMetricsDelete_589096, base: "/",
    url: url_LoggingProjectsMetricsDelete_589097, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsExclusionsGet_589114 = ref object of OpenApiRestCall_588441
proc url_LoggingOrganizationsExclusionsGet_589116(protocol: Scheme; host: string;
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

proc validate_LoggingOrganizationsExclusionsGet_589115(path: JsonNode;
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
  var valid_589117 = path.getOrDefault("name")
  valid_589117 = validateParameter(valid_589117, JString, required = true,
                                 default = nil)
  if valid_589117 != nil:
    section.add "name", valid_589117
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
  var valid_589118 = query.getOrDefault("upload_protocol")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "upload_protocol", valid_589118
  var valid_589119 = query.getOrDefault("fields")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "fields", valid_589119
  var valid_589120 = query.getOrDefault("quotaUser")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "quotaUser", valid_589120
  var valid_589121 = query.getOrDefault("alt")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = newJString("json"))
  if valid_589121 != nil:
    section.add "alt", valid_589121
  var valid_589122 = query.getOrDefault("oauth_token")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "oauth_token", valid_589122
  var valid_589123 = query.getOrDefault("callback")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "callback", valid_589123
  var valid_589124 = query.getOrDefault("access_token")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "access_token", valid_589124
  var valid_589125 = query.getOrDefault("uploadType")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "uploadType", valid_589125
  var valid_589126 = query.getOrDefault("key")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "key", valid_589126
  var valid_589127 = query.getOrDefault("$.xgafv")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = newJString("1"))
  if valid_589127 != nil:
    section.add "$.xgafv", valid_589127
  var valid_589128 = query.getOrDefault("prettyPrint")
  valid_589128 = validateParameter(valid_589128, JBool, required = false,
                                 default = newJBool(true))
  if valid_589128 != nil:
    section.add "prettyPrint", valid_589128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589129: Call_LoggingOrganizationsExclusionsGet_589114;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the description of an exclusion.
  ## 
  let valid = call_589129.validator(path, query, header, formData, body)
  let scheme = call_589129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589129.url(scheme.get, call_589129.host, call_589129.base,
                         call_589129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589129, url, valid)

proc call*(call_589130: Call_LoggingOrganizationsExclusionsGet_589114;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## loggingOrganizationsExclusionsGet
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
  var path_589131 = newJObject()
  var query_589132 = newJObject()
  add(query_589132, "upload_protocol", newJString(uploadProtocol))
  add(query_589132, "fields", newJString(fields))
  add(query_589132, "quotaUser", newJString(quotaUser))
  add(path_589131, "name", newJString(name))
  add(query_589132, "alt", newJString(alt))
  add(query_589132, "oauth_token", newJString(oauthToken))
  add(query_589132, "callback", newJString(callback))
  add(query_589132, "access_token", newJString(accessToken))
  add(query_589132, "uploadType", newJString(uploadType))
  add(query_589132, "key", newJString(key))
  add(query_589132, "$.xgafv", newJString(Xgafv))
  add(query_589132, "prettyPrint", newJBool(prettyPrint))
  result = call_589130.call(path_589131, query_589132, nil, nil, nil)

var loggingOrganizationsExclusionsGet* = Call_LoggingOrganizationsExclusionsGet_589114(
    name: "loggingOrganizationsExclusionsGet", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{name}",
    validator: validate_LoggingOrganizationsExclusionsGet_589115, base: "/",
    url: url_LoggingOrganizationsExclusionsGet_589116, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsExclusionsPatch_589152 = ref object of OpenApiRestCall_588441
proc url_LoggingOrganizationsExclusionsPatch_589154(protocol: Scheme; host: string;
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

proc validate_LoggingOrganizationsExclusionsPatch_589153(path: JsonNode;
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
  var valid_589155 = path.getOrDefault("name")
  valid_589155 = validateParameter(valid_589155, JString, required = true,
                                 default = nil)
  if valid_589155 != nil:
    section.add "name", valid_589155
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
  var valid_589156 = query.getOrDefault("upload_protocol")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "upload_protocol", valid_589156
  var valid_589157 = query.getOrDefault("fields")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "fields", valid_589157
  var valid_589158 = query.getOrDefault("quotaUser")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "quotaUser", valid_589158
  var valid_589159 = query.getOrDefault("alt")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = newJString("json"))
  if valid_589159 != nil:
    section.add "alt", valid_589159
  var valid_589160 = query.getOrDefault("oauth_token")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "oauth_token", valid_589160
  var valid_589161 = query.getOrDefault("callback")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "callback", valid_589161
  var valid_589162 = query.getOrDefault("access_token")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "access_token", valid_589162
  var valid_589163 = query.getOrDefault("uploadType")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "uploadType", valid_589163
  var valid_589164 = query.getOrDefault("key")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "key", valid_589164
  var valid_589165 = query.getOrDefault("$.xgafv")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = newJString("1"))
  if valid_589165 != nil:
    section.add "$.xgafv", valid_589165
  var valid_589166 = query.getOrDefault("prettyPrint")
  valid_589166 = validateParameter(valid_589166, JBool, required = false,
                                 default = newJBool(true))
  if valid_589166 != nil:
    section.add "prettyPrint", valid_589166
  var valid_589167 = query.getOrDefault("updateMask")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "updateMask", valid_589167
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

proc call*(call_589169: Call_LoggingOrganizationsExclusionsPatch_589152;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Changes one or more properties of an existing exclusion.
  ## 
  let valid = call_589169.validator(path, query, header, formData, body)
  let scheme = call_589169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589169.url(scheme.get, call_589169.host, call_589169.base,
                         call_589169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589169, url, valid)

proc call*(call_589170: Call_LoggingOrganizationsExclusionsPatch_589152;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## loggingOrganizationsExclusionsPatch
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
  var path_589171 = newJObject()
  var query_589172 = newJObject()
  var body_589173 = newJObject()
  add(query_589172, "upload_protocol", newJString(uploadProtocol))
  add(query_589172, "fields", newJString(fields))
  add(query_589172, "quotaUser", newJString(quotaUser))
  add(path_589171, "name", newJString(name))
  add(query_589172, "alt", newJString(alt))
  add(query_589172, "oauth_token", newJString(oauthToken))
  add(query_589172, "callback", newJString(callback))
  add(query_589172, "access_token", newJString(accessToken))
  add(query_589172, "uploadType", newJString(uploadType))
  add(query_589172, "key", newJString(key))
  add(query_589172, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589173 = body
  add(query_589172, "prettyPrint", newJBool(prettyPrint))
  add(query_589172, "updateMask", newJString(updateMask))
  result = call_589170.call(path_589171, query_589172, nil, nil, body_589173)

var loggingOrganizationsExclusionsPatch* = Call_LoggingOrganizationsExclusionsPatch_589152(
    name: "loggingOrganizationsExclusionsPatch", meth: HttpMethod.HttpPatch,
    host: "logging.googleapis.com", route: "/v2/{name}",
    validator: validate_LoggingOrganizationsExclusionsPatch_589153, base: "/",
    url: url_LoggingOrganizationsExclusionsPatch_589154, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsExclusionsDelete_589133 = ref object of OpenApiRestCall_588441
proc url_LoggingOrganizationsExclusionsDelete_589135(protocol: Scheme;
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

proc validate_LoggingOrganizationsExclusionsDelete_589134(path: JsonNode;
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
  var valid_589136 = path.getOrDefault("name")
  valid_589136 = validateParameter(valid_589136, JString, required = true,
                                 default = nil)
  if valid_589136 != nil:
    section.add "name", valid_589136
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
  var valid_589137 = query.getOrDefault("upload_protocol")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "upload_protocol", valid_589137
  var valid_589138 = query.getOrDefault("fields")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "fields", valid_589138
  var valid_589139 = query.getOrDefault("quotaUser")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "quotaUser", valid_589139
  var valid_589140 = query.getOrDefault("alt")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = newJString("json"))
  if valid_589140 != nil:
    section.add "alt", valid_589140
  var valid_589141 = query.getOrDefault("oauth_token")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "oauth_token", valid_589141
  var valid_589142 = query.getOrDefault("callback")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "callback", valid_589142
  var valid_589143 = query.getOrDefault("access_token")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "access_token", valid_589143
  var valid_589144 = query.getOrDefault("uploadType")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "uploadType", valid_589144
  var valid_589145 = query.getOrDefault("key")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "key", valid_589145
  var valid_589146 = query.getOrDefault("$.xgafv")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = newJString("1"))
  if valid_589146 != nil:
    section.add "$.xgafv", valid_589146
  var valid_589147 = query.getOrDefault("prettyPrint")
  valid_589147 = validateParameter(valid_589147, JBool, required = false,
                                 default = newJBool(true))
  if valid_589147 != nil:
    section.add "prettyPrint", valid_589147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589148: Call_LoggingOrganizationsExclusionsDelete_589133;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an exclusion.
  ## 
  let valid = call_589148.validator(path, query, header, formData, body)
  let scheme = call_589148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589148.url(scheme.get, call_589148.host, call_589148.base,
                         call_589148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589148, url, valid)

proc call*(call_589149: Call_LoggingOrganizationsExclusionsDelete_589133;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## loggingOrganizationsExclusionsDelete
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
  var path_589150 = newJObject()
  var query_589151 = newJObject()
  add(query_589151, "upload_protocol", newJString(uploadProtocol))
  add(query_589151, "fields", newJString(fields))
  add(query_589151, "quotaUser", newJString(quotaUser))
  add(path_589150, "name", newJString(name))
  add(query_589151, "alt", newJString(alt))
  add(query_589151, "oauth_token", newJString(oauthToken))
  add(query_589151, "callback", newJString(callback))
  add(query_589151, "access_token", newJString(accessToken))
  add(query_589151, "uploadType", newJString(uploadType))
  add(query_589151, "key", newJString(key))
  add(query_589151, "$.xgafv", newJString(Xgafv))
  add(query_589151, "prettyPrint", newJBool(prettyPrint))
  result = call_589149.call(path_589150, query_589151, nil, nil, nil)

var loggingOrganizationsExclusionsDelete* = Call_LoggingOrganizationsExclusionsDelete_589133(
    name: "loggingOrganizationsExclusionsDelete", meth: HttpMethod.HttpDelete,
    host: "logging.googleapis.com", route: "/v2/{name}",
    validator: validate_LoggingOrganizationsExclusionsDelete_589134, base: "/",
    url: url_LoggingOrganizationsExclusionsDelete_589135, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsExclusionsCreate_589195 = ref object of OpenApiRestCall_588441
proc url_LoggingOrganizationsExclusionsCreate_589197(protocol: Scheme;
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

proc validate_LoggingOrganizationsExclusionsCreate_589196(path: JsonNode;
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
  var valid_589198 = path.getOrDefault("parent")
  valid_589198 = validateParameter(valid_589198, JString, required = true,
                                 default = nil)
  if valid_589198 != nil:
    section.add "parent", valid_589198
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
  var valid_589199 = query.getOrDefault("upload_protocol")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "upload_protocol", valid_589199
  var valid_589200 = query.getOrDefault("fields")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "fields", valid_589200
  var valid_589201 = query.getOrDefault("quotaUser")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "quotaUser", valid_589201
  var valid_589202 = query.getOrDefault("alt")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = newJString("json"))
  if valid_589202 != nil:
    section.add "alt", valid_589202
  var valid_589203 = query.getOrDefault("oauth_token")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "oauth_token", valid_589203
  var valid_589204 = query.getOrDefault("callback")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "callback", valid_589204
  var valid_589205 = query.getOrDefault("access_token")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "access_token", valid_589205
  var valid_589206 = query.getOrDefault("uploadType")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "uploadType", valid_589206
  var valid_589207 = query.getOrDefault("key")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "key", valid_589207
  var valid_589208 = query.getOrDefault("$.xgafv")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = newJString("1"))
  if valid_589208 != nil:
    section.add "$.xgafv", valid_589208
  var valid_589209 = query.getOrDefault("prettyPrint")
  valid_589209 = validateParameter(valid_589209, JBool, required = false,
                                 default = newJBool(true))
  if valid_589209 != nil:
    section.add "prettyPrint", valid_589209
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

proc call*(call_589211: Call_LoggingOrganizationsExclusionsCreate_589195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new exclusion in a specified parent resource. Only log entries belonging to that resource can be excluded. You can have up to 10 exclusions in a resource.
  ## 
  let valid = call_589211.validator(path, query, header, formData, body)
  let scheme = call_589211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589211.url(scheme.get, call_589211.host, call_589211.base,
                         call_589211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589211, url, valid)

proc call*(call_589212: Call_LoggingOrganizationsExclusionsCreate_589195;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## loggingOrganizationsExclusionsCreate
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
  var path_589213 = newJObject()
  var query_589214 = newJObject()
  var body_589215 = newJObject()
  add(query_589214, "upload_protocol", newJString(uploadProtocol))
  add(query_589214, "fields", newJString(fields))
  add(query_589214, "quotaUser", newJString(quotaUser))
  add(query_589214, "alt", newJString(alt))
  add(query_589214, "oauth_token", newJString(oauthToken))
  add(query_589214, "callback", newJString(callback))
  add(query_589214, "access_token", newJString(accessToken))
  add(query_589214, "uploadType", newJString(uploadType))
  add(path_589213, "parent", newJString(parent))
  add(query_589214, "key", newJString(key))
  add(query_589214, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589215 = body
  add(query_589214, "prettyPrint", newJBool(prettyPrint))
  result = call_589212.call(path_589213, query_589214, nil, nil, body_589215)

var loggingOrganizationsExclusionsCreate* = Call_LoggingOrganizationsExclusionsCreate_589195(
    name: "loggingOrganizationsExclusionsCreate", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2/{parent}/exclusions",
    validator: validate_LoggingOrganizationsExclusionsCreate_589196, base: "/",
    url: url_LoggingOrganizationsExclusionsCreate_589197, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsExclusionsList_589174 = ref object of OpenApiRestCall_588441
proc url_LoggingOrganizationsExclusionsList_589176(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_LoggingOrganizationsExclusionsList_589175(path: JsonNode;
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
  var valid_589177 = path.getOrDefault("parent")
  valid_589177 = validateParameter(valid_589177, JString, required = true,
                                 default = nil)
  if valid_589177 != nil:
    section.add "parent", valid_589177
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
  var valid_589178 = query.getOrDefault("upload_protocol")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "upload_protocol", valid_589178
  var valid_589179 = query.getOrDefault("fields")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "fields", valid_589179
  var valid_589180 = query.getOrDefault("pageToken")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "pageToken", valid_589180
  var valid_589181 = query.getOrDefault("quotaUser")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "quotaUser", valid_589181
  var valid_589182 = query.getOrDefault("alt")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = newJString("json"))
  if valid_589182 != nil:
    section.add "alt", valid_589182
  var valid_589183 = query.getOrDefault("oauth_token")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "oauth_token", valid_589183
  var valid_589184 = query.getOrDefault("callback")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "callback", valid_589184
  var valid_589185 = query.getOrDefault("access_token")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "access_token", valid_589185
  var valid_589186 = query.getOrDefault("uploadType")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "uploadType", valid_589186
  var valid_589187 = query.getOrDefault("key")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "key", valid_589187
  var valid_589188 = query.getOrDefault("$.xgafv")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = newJString("1"))
  if valid_589188 != nil:
    section.add "$.xgafv", valid_589188
  var valid_589189 = query.getOrDefault("pageSize")
  valid_589189 = validateParameter(valid_589189, JInt, required = false, default = nil)
  if valid_589189 != nil:
    section.add "pageSize", valid_589189
  var valid_589190 = query.getOrDefault("prettyPrint")
  valid_589190 = validateParameter(valid_589190, JBool, required = false,
                                 default = newJBool(true))
  if valid_589190 != nil:
    section.add "prettyPrint", valid_589190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589191: Call_LoggingOrganizationsExclusionsList_589174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the exclusions in a parent resource.
  ## 
  let valid = call_589191.validator(path, query, header, formData, body)
  let scheme = call_589191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589191.url(scheme.get, call_589191.host, call_589191.base,
                         call_589191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589191, url, valid)

proc call*(call_589192: Call_LoggingOrganizationsExclusionsList_589174;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## loggingOrganizationsExclusionsList
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
  var path_589193 = newJObject()
  var query_589194 = newJObject()
  add(query_589194, "upload_protocol", newJString(uploadProtocol))
  add(query_589194, "fields", newJString(fields))
  add(query_589194, "pageToken", newJString(pageToken))
  add(query_589194, "quotaUser", newJString(quotaUser))
  add(query_589194, "alt", newJString(alt))
  add(query_589194, "oauth_token", newJString(oauthToken))
  add(query_589194, "callback", newJString(callback))
  add(query_589194, "access_token", newJString(accessToken))
  add(query_589194, "uploadType", newJString(uploadType))
  add(path_589193, "parent", newJString(parent))
  add(query_589194, "key", newJString(key))
  add(query_589194, "$.xgafv", newJString(Xgafv))
  add(query_589194, "pageSize", newJInt(pageSize))
  add(query_589194, "prettyPrint", newJBool(prettyPrint))
  result = call_589192.call(path_589193, query_589194, nil, nil, nil)

var loggingOrganizationsExclusionsList* = Call_LoggingOrganizationsExclusionsList_589174(
    name: "loggingOrganizationsExclusionsList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{parent}/exclusions",
    validator: validate_LoggingOrganizationsExclusionsList_589175, base: "/",
    url: url_LoggingOrganizationsExclusionsList_589176, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsLogsList_589216 = ref object of OpenApiRestCall_588441
proc url_LoggingOrganizationsLogsList_589218(protocol: Scheme; host: string;
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

proc validate_LoggingOrganizationsLogsList_589217(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_589219 = path.getOrDefault("parent")
  valid_589219 = validateParameter(valid_589219, JString, required = true,
                                 default = nil)
  if valid_589219 != nil:
    section.add "parent", valid_589219
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
  var valid_589220 = query.getOrDefault("upload_protocol")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "upload_protocol", valid_589220
  var valid_589221 = query.getOrDefault("fields")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "fields", valid_589221
  var valid_589222 = query.getOrDefault("pageToken")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "pageToken", valid_589222
  var valid_589223 = query.getOrDefault("quotaUser")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "quotaUser", valid_589223
  var valid_589224 = query.getOrDefault("alt")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = newJString("json"))
  if valid_589224 != nil:
    section.add "alt", valid_589224
  var valid_589225 = query.getOrDefault("oauth_token")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "oauth_token", valid_589225
  var valid_589226 = query.getOrDefault("callback")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "callback", valid_589226
  var valid_589227 = query.getOrDefault("access_token")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "access_token", valid_589227
  var valid_589228 = query.getOrDefault("uploadType")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "uploadType", valid_589228
  var valid_589229 = query.getOrDefault("key")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "key", valid_589229
  var valid_589230 = query.getOrDefault("$.xgafv")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = newJString("1"))
  if valid_589230 != nil:
    section.add "$.xgafv", valid_589230
  var valid_589231 = query.getOrDefault("pageSize")
  valid_589231 = validateParameter(valid_589231, JInt, required = false, default = nil)
  if valid_589231 != nil:
    section.add "pageSize", valid_589231
  var valid_589232 = query.getOrDefault("prettyPrint")
  valid_589232 = validateParameter(valid_589232, JBool, required = false,
                                 default = newJBool(true))
  if valid_589232 != nil:
    section.add "prettyPrint", valid_589232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589233: Call_LoggingOrganizationsLogsList_589216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the logs in projects, organizations, folders, or billing accounts. Only logs that have entries are listed.
  ## 
  let valid = call_589233.validator(path, query, header, formData, body)
  let scheme = call_589233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589233.url(scheme.get, call_589233.host, call_589233.base,
                         call_589233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589233, url, valid)

proc call*(call_589234: Call_LoggingOrganizationsLogsList_589216; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## loggingOrganizationsLogsList
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
  var path_589235 = newJObject()
  var query_589236 = newJObject()
  add(query_589236, "upload_protocol", newJString(uploadProtocol))
  add(query_589236, "fields", newJString(fields))
  add(query_589236, "pageToken", newJString(pageToken))
  add(query_589236, "quotaUser", newJString(quotaUser))
  add(query_589236, "alt", newJString(alt))
  add(query_589236, "oauth_token", newJString(oauthToken))
  add(query_589236, "callback", newJString(callback))
  add(query_589236, "access_token", newJString(accessToken))
  add(query_589236, "uploadType", newJString(uploadType))
  add(path_589235, "parent", newJString(parent))
  add(query_589236, "key", newJString(key))
  add(query_589236, "$.xgafv", newJString(Xgafv))
  add(query_589236, "pageSize", newJInt(pageSize))
  add(query_589236, "prettyPrint", newJBool(prettyPrint))
  result = call_589234.call(path_589235, query_589236, nil, nil, nil)

var loggingOrganizationsLogsList* = Call_LoggingOrganizationsLogsList_589216(
    name: "loggingOrganizationsLogsList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{parent}/logs",
    validator: validate_LoggingOrganizationsLogsList_589217, base: "/",
    url: url_LoggingOrganizationsLogsList_589218, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsCreate_589258 = ref object of OpenApiRestCall_588441
proc url_LoggingProjectsMetricsCreate_589260(protocol: Scheme; host: string;
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

proc validate_LoggingProjectsMetricsCreate_589259(path: JsonNode; query: JsonNode;
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
  var valid_589261 = path.getOrDefault("parent")
  valid_589261 = validateParameter(valid_589261, JString, required = true,
                                 default = nil)
  if valid_589261 != nil:
    section.add "parent", valid_589261
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
  var valid_589262 = query.getOrDefault("upload_protocol")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "upload_protocol", valid_589262
  var valid_589263 = query.getOrDefault("fields")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "fields", valid_589263
  var valid_589264 = query.getOrDefault("quotaUser")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "quotaUser", valid_589264
  var valid_589265 = query.getOrDefault("alt")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = newJString("json"))
  if valid_589265 != nil:
    section.add "alt", valid_589265
  var valid_589266 = query.getOrDefault("oauth_token")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "oauth_token", valid_589266
  var valid_589267 = query.getOrDefault("callback")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "callback", valid_589267
  var valid_589268 = query.getOrDefault("access_token")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "access_token", valid_589268
  var valid_589269 = query.getOrDefault("uploadType")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "uploadType", valid_589269
  var valid_589270 = query.getOrDefault("key")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "key", valid_589270
  var valid_589271 = query.getOrDefault("$.xgafv")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = newJString("1"))
  if valid_589271 != nil:
    section.add "$.xgafv", valid_589271
  var valid_589272 = query.getOrDefault("prettyPrint")
  valid_589272 = validateParameter(valid_589272, JBool, required = false,
                                 default = newJBool(true))
  if valid_589272 != nil:
    section.add "prettyPrint", valid_589272
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

proc call*(call_589274: Call_LoggingProjectsMetricsCreate_589258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a logs-based metric.
  ## 
  let valid = call_589274.validator(path, query, header, formData, body)
  let scheme = call_589274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589274.url(scheme.get, call_589274.host, call_589274.base,
                         call_589274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589274, url, valid)

proc call*(call_589275: Call_LoggingProjectsMetricsCreate_589258; parent: string;
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
  var path_589276 = newJObject()
  var query_589277 = newJObject()
  var body_589278 = newJObject()
  add(query_589277, "upload_protocol", newJString(uploadProtocol))
  add(query_589277, "fields", newJString(fields))
  add(query_589277, "quotaUser", newJString(quotaUser))
  add(query_589277, "alt", newJString(alt))
  add(query_589277, "oauth_token", newJString(oauthToken))
  add(query_589277, "callback", newJString(callback))
  add(query_589277, "access_token", newJString(accessToken))
  add(query_589277, "uploadType", newJString(uploadType))
  add(path_589276, "parent", newJString(parent))
  add(query_589277, "key", newJString(key))
  add(query_589277, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589278 = body
  add(query_589277, "prettyPrint", newJBool(prettyPrint))
  result = call_589275.call(path_589276, query_589277, nil, nil, body_589278)

var loggingProjectsMetricsCreate* = Call_LoggingProjectsMetricsCreate_589258(
    name: "loggingProjectsMetricsCreate", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2/{parent}/metrics",
    validator: validate_LoggingProjectsMetricsCreate_589259, base: "/",
    url: url_LoggingProjectsMetricsCreate_589260, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsList_589237 = ref object of OpenApiRestCall_588441
proc url_LoggingProjectsMetricsList_589239(protocol: Scheme; host: string;
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

proc validate_LoggingProjectsMetricsList_589238(path: JsonNode; query: JsonNode;
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
  var valid_589240 = path.getOrDefault("parent")
  valid_589240 = validateParameter(valid_589240, JString, required = true,
                                 default = nil)
  if valid_589240 != nil:
    section.add "parent", valid_589240
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
  var valid_589241 = query.getOrDefault("upload_protocol")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "upload_protocol", valid_589241
  var valid_589242 = query.getOrDefault("fields")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "fields", valid_589242
  var valid_589243 = query.getOrDefault("pageToken")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "pageToken", valid_589243
  var valid_589244 = query.getOrDefault("quotaUser")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "quotaUser", valid_589244
  var valid_589245 = query.getOrDefault("alt")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = newJString("json"))
  if valid_589245 != nil:
    section.add "alt", valid_589245
  var valid_589246 = query.getOrDefault("oauth_token")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "oauth_token", valid_589246
  var valid_589247 = query.getOrDefault("callback")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "callback", valid_589247
  var valid_589248 = query.getOrDefault("access_token")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "access_token", valid_589248
  var valid_589249 = query.getOrDefault("uploadType")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "uploadType", valid_589249
  var valid_589250 = query.getOrDefault("key")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "key", valid_589250
  var valid_589251 = query.getOrDefault("$.xgafv")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = newJString("1"))
  if valid_589251 != nil:
    section.add "$.xgafv", valid_589251
  var valid_589252 = query.getOrDefault("pageSize")
  valid_589252 = validateParameter(valid_589252, JInt, required = false, default = nil)
  if valid_589252 != nil:
    section.add "pageSize", valid_589252
  var valid_589253 = query.getOrDefault("prettyPrint")
  valid_589253 = validateParameter(valid_589253, JBool, required = false,
                                 default = newJBool(true))
  if valid_589253 != nil:
    section.add "prettyPrint", valid_589253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589254: Call_LoggingProjectsMetricsList_589237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists logs-based metrics.
  ## 
  let valid = call_589254.validator(path, query, header, formData, body)
  let scheme = call_589254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589254.url(scheme.get, call_589254.host, call_589254.base,
                         call_589254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589254, url, valid)

proc call*(call_589255: Call_LoggingProjectsMetricsList_589237; parent: string;
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
  var path_589256 = newJObject()
  var query_589257 = newJObject()
  add(query_589257, "upload_protocol", newJString(uploadProtocol))
  add(query_589257, "fields", newJString(fields))
  add(query_589257, "pageToken", newJString(pageToken))
  add(query_589257, "quotaUser", newJString(quotaUser))
  add(query_589257, "alt", newJString(alt))
  add(query_589257, "oauth_token", newJString(oauthToken))
  add(query_589257, "callback", newJString(callback))
  add(query_589257, "access_token", newJString(accessToken))
  add(query_589257, "uploadType", newJString(uploadType))
  add(path_589256, "parent", newJString(parent))
  add(query_589257, "key", newJString(key))
  add(query_589257, "$.xgafv", newJString(Xgafv))
  add(query_589257, "pageSize", newJInt(pageSize))
  add(query_589257, "prettyPrint", newJBool(prettyPrint))
  result = call_589255.call(path_589256, query_589257, nil, nil, nil)

var loggingProjectsMetricsList* = Call_LoggingProjectsMetricsList_589237(
    name: "loggingProjectsMetricsList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{parent}/metrics",
    validator: validate_LoggingProjectsMetricsList_589238, base: "/",
    url: url_LoggingProjectsMetricsList_589239, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsSinksCreate_589300 = ref object of OpenApiRestCall_588441
proc url_LoggingOrganizationsSinksCreate_589302(protocol: Scheme; host: string;
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

proc validate_LoggingOrganizationsSinksCreate_589301(path: JsonNode;
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
  var valid_589303 = path.getOrDefault("parent")
  valid_589303 = validateParameter(valid_589303, JString, required = true,
                                 default = nil)
  if valid_589303 != nil:
    section.add "parent", valid_589303
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
  var valid_589304 = query.getOrDefault("upload_protocol")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = nil)
  if valid_589304 != nil:
    section.add "upload_protocol", valid_589304
  var valid_589305 = query.getOrDefault("fields")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "fields", valid_589305
  var valid_589306 = query.getOrDefault("quotaUser")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "quotaUser", valid_589306
  var valid_589307 = query.getOrDefault("alt")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = newJString("json"))
  if valid_589307 != nil:
    section.add "alt", valid_589307
  var valid_589308 = query.getOrDefault("uniqueWriterIdentity")
  valid_589308 = validateParameter(valid_589308, JBool, required = false, default = nil)
  if valid_589308 != nil:
    section.add "uniqueWriterIdentity", valid_589308
  var valid_589309 = query.getOrDefault("oauth_token")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "oauth_token", valid_589309
  var valid_589310 = query.getOrDefault("callback")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "callback", valid_589310
  var valid_589311 = query.getOrDefault("access_token")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "access_token", valid_589311
  var valid_589312 = query.getOrDefault("uploadType")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "uploadType", valid_589312
  var valid_589313 = query.getOrDefault("key")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = nil)
  if valid_589313 != nil:
    section.add "key", valid_589313
  var valid_589314 = query.getOrDefault("$.xgafv")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = newJString("1"))
  if valid_589314 != nil:
    section.add "$.xgafv", valid_589314
  var valid_589315 = query.getOrDefault("prettyPrint")
  valid_589315 = validateParameter(valid_589315, JBool, required = false,
                                 default = newJBool(true))
  if valid_589315 != nil:
    section.add "prettyPrint", valid_589315
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

proc call*(call_589317: Call_LoggingOrganizationsSinksCreate_589300;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a sink that exports specified log entries to a destination. The export of newly-ingested log entries begins immediately, unless the sink's writer_identity is not permitted to write to the destination. A sink can export log entries only from the resource owning the sink.
  ## 
  let valid = call_589317.validator(path, query, header, formData, body)
  let scheme = call_589317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589317.url(scheme.get, call_589317.host, call_589317.base,
                         call_589317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589317, url, valid)

proc call*(call_589318: Call_LoggingOrganizationsSinksCreate_589300;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          uniqueWriterIdentity: bool = false; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## loggingOrganizationsSinksCreate
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
  var path_589319 = newJObject()
  var query_589320 = newJObject()
  var body_589321 = newJObject()
  add(query_589320, "upload_protocol", newJString(uploadProtocol))
  add(query_589320, "fields", newJString(fields))
  add(query_589320, "quotaUser", newJString(quotaUser))
  add(query_589320, "alt", newJString(alt))
  add(query_589320, "uniqueWriterIdentity", newJBool(uniqueWriterIdentity))
  add(query_589320, "oauth_token", newJString(oauthToken))
  add(query_589320, "callback", newJString(callback))
  add(query_589320, "access_token", newJString(accessToken))
  add(query_589320, "uploadType", newJString(uploadType))
  add(path_589319, "parent", newJString(parent))
  add(query_589320, "key", newJString(key))
  add(query_589320, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589321 = body
  add(query_589320, "prettyPrint", newJBool(prettyPrint))
  result = call_589318.call(path_589319, query_589320, nil, nil, body_589321)

var loggingOrganizationsSinksCreate* = Call_LoggingOrganizationsSinksCreate_589300(
    name: "loggingOrganizationsSinksCreate", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2/{parent}/sinks",
    validator: validate_LoggingOrganizationsSinksCreate_589301, base: "/",
    url: url_LoggingOrganizationsSinksCreate_589302, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsSinksList_589279 = ref object of OpenApiRestCall_588441
proc url_LoggingOrganizationsSinksList_589281(protocol: Scheme; host: string;
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

proc validate_LoggingOrganizationsSinksList_589280(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_589282 = path.getOrDefault("parent")
  valid_589282 = validateParameter(valid_589282, JString, required = true,
                                 default = nil)
  if valid_589282 != nil:
    section.add "parent", valid_589282
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
  var valid_589283 = query.getOrDefault("upload_protocol")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "upload_protocol", valid_589283
  var valid_589284 = query.getOrDefault("fields")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "fields", valid_589284
  var valid_589285 = query.getOrDefault("pageToken")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "pageToken", valid_589285
  var valid_589286 = query.getOrDefault("quotaUser")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "quotaUser", valid_589286
  var valid_589287 = query.getOrDefault("alt")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = newJString("json"))
  if valid_589287 != nil:
    section.add "alt", valid_589287
  var valid_589288 = query.getOrDefault("oauth_token")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "oauth_token", valid_589288
  var valid_589289 = query.getOrDefault("callback")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "callback", valid_589289
  var valid_589290 = query.getOrDefault("access_token")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "access_token", valid_589290
  var valid_589291 = query.getOrDefault("uploadType")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "uploadType", valid_589291
  var valid_589292 = query.getOrDefault("key")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "key", valid_589292
  var valid_589293 = query.getOrDefault("$.xgafv")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = newJString("1"))
  if valid_589293 != nil:
    section.add "$.xgafv", valid_589293
  var valid_589294 = query.getOrDefault("pageSize")
  valid_589294 = validateParameter(valid_589294, JInt, required = false, default = nil)
  if valid_589294 != nil:
    section.add "pageSize", valid_589294
  var valid_589295 = query.getOrDefault("prettyPrint")
  valid_589295 = validateParameter(valid_589295, JBool, required = false,
                                 default = newJBool(true))
  if valid_589295 != nil:
    section.add "prettyPrint", valid_589295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589296: Call_LoggingOrganizationsSinksList_589279; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists sinks.
  ## 
  let valid = call_589296.validator(path, query, header, formData, body)
  let scheme = call_589296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589296.url(scheme.get, call_589296.host, call_589296.base,
                         call_589296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589296, url, valid)

proc call*(call_589297: Call_LoggingOrganizationsSinksList_589279; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## loggingOrganizationsSinksList
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
  var path_589298 = newJObject()
  var query_589299 = newJObject()
  add(query_589299, "upload_protocol", newJString(uploadProtocol))
  add(query_589299, "fields", newJString(fields))
  add(query_589299, "pageToken", newJString(pageToken))
  add(query_589299, "quotaUser", newJString(quotaUser))
  add(query_589299, "alt", newJString(alt))
  add(query_589299, "oauth_token", newJString(oauthToken))
  add(query_589299, "callback", newJString(callback))
  add(query_589299, "access_token", newJString(accessToken))
  add(query_589299, "uploadType", newJString(uploadType))
  add(path_589298, "parent", newJString(parent))
  add(query_589299, "key", newJString(key))
  add(query_589299, "$.xgafv", newJString(Xgafv))
  add(query_589299, "pageSize", newJInt(pageSize))
  add(query_589299, "prettyPrint", newJBool(prettyPrint))
  result = call_589297.call(path_589298, query_589299, nil, nil, nil)

var loggingOrganizationsSinksList* = Call_LoggingOrganizationsSinksList_589279(
    name: "loggingOrganizationsSinksList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{parent}/sinks",
    validator: validate_LoggingOrganizationsSinksList_589280, base: "/",
    url: url_LoggingOrganizationsSinksList_589281, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsSinksUpdate_589341 = ref object of OpenApiRestCall_588441
proc url_LoggingOrganizationsSinksUpdate_589343(protocol: Scheme; host: string;
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

proc validate_LoggingOrganizationsSinksUpdate_589342(path: JsonNode;
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
  var valid_589344 = path.getOrDefault("sinkName")
  valid_589344 = validateParameter(valid_589344, JString, required = true,
                                 default = nil)
  if valid_589344 != nil:
    section.add "sinkName", valid_589344
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
  var valid_589345 = query.getOrDefault("upload_protocol")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "upload_protocol", valid_589345
  var valid_589346 = query.getOrDefault("fields")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "fields", valid_589346
  var valid_589347 = query.getOrDefault("quotaUser")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "quotaUser", valid_589347
  var valid_589348 = query.getOrDefault("alt")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = newJString("json"))
  if valid_589348 != nil:
    section.add "alt", valid_589348
  var valid_589349 = query.getOrDefault("uniqueWriterIdentity")
  valid_589349 = validateParameter(valid_589349, JBool, required = false, default = nil)
  if valid_589349 != nil:
    section.add "uniqueWriterIdentity", valid_589349
  var valid_589350 = query.getOrDefault("oauth_token")
  valid_589350 = validateParameter(valid_589350, JString, required = false,
                                 default = nil)
  if valid_589350 != nil:
    section.add "oauth_token", valid_589350
  var valid_589351 = query.getOrDefault("callback")
  valid_589351 = validateParameter(valid_589351, JString, required = false,
                                 default = nil)
  if valid_589351 != nil:
    section.add "callback", valid_589351
  var valid_589352 = query.getOrDefault("access_token")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "access_token", valid_589352
  var valid_589353 = query.getOrDefault("uploadType")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = nil)
  if valid_589353 != nil:
    section.add "uploadType", valid_589353
  var valid_589354 = query.getOrDefault("key")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = nil)
  if valid_589354 != nil:
    section.add "key", valid_589354
  var valid_589355 = query.getOrDefault("$.xgafv")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = newJString("1"))
  if valid_589355 != nil:
    section.add "$.xgafv", valid_589355
  var valid_589356 = query.getOrDefault("prettyPrint")
  valid_589356 = validateParameter(valid_589356, JBool, required = false,
                                 default = newJBool(true))
  if valid_589356 != nil:
    section.add "prettyPrint", valid_589356
  var valid_589357 = query.getOrDefault("updateMask")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "updateMask", valid_589357
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

proc call*(call_589359: Call_LoggingOrganizationsSinksUpdate_589341;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a sink. This method replaces the following fields in the existing sink with values from the new sink: destination, and filter.The updated sink might also have a new writer_identity; see the unique_writer_identity field.
  ## 
  let valid = call_589359.validator(path, query, header, formData, body)
  let scheme = call_589359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589359.url(scheme.get, call_589359.host, call_589359.base,
                         call_589359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589359, url, valid)

proc call*(call_589360: Call_LoggingOrganizationsSinksUpdate_589341;
          sinkName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          uniqueWriterIdentity: bool = false; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## loggingOrganizationsSinksUpdate
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
  var path_589361 = newJObject()
  var query_589362 = newJObject()
  var body_589363 = newJObject()
  add(query_589362, "upload_protocol", newJString(uploadProtocol))
  add(query_589362, "fields", newJString(fields))
  add(query_589362, "quotaUser", newJString(quotaUser))
  add(path_589361, "sinkName", newJString(sinkName))
  add(query_589362, "alt", newJString(alt))
  add(query_589362, "uniqueWriterIdentity", newJBool(uniqueWriterIdentity))
  add(query_589362, "oauth_token", newJString(oauthToken))
  add(query_589362, "callback", newJString(callback))
  add(query_589362, "access_token", newJString(accessToken))
  add(query_589362, "uploadType", newJString(uploadType))
  add(query_589362, "key", newJString(key))
  add(query_589362, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589363 = body
  add(query_589362, "prettyPrint", newJBool(prettyPrint))
  add(query_589362, "updateMask", newJString(updateMask))
  result = call_589360.call(path_589361, query_589362, nil, nil, body_589363)

var loggingOrganizationsSinksUpdate* = Call_LoggingOrganizationsSinksUpdate_589341(
    name: "loggingOrganizationsSinksUpdate", meth: HttpMethod.HttpPut,
    host: "logging.googleapis.com", route: "/v2/{sinkName}",
    validator: validate_LoggingOrganizationsSinksUpdate_589342, base: "/",
    url: url_LoggingOrganizationsSinksUpdate_589343, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsSinksGet_589322 = ref object of OpenApiRestCall_588441
proc url_LoggingOrganizationsSinksGet_589324(protocol: Scheme; host: string;
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

proc validate_LoggingOrganizationsSinksGet_589323(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_589325 = path.getOrDefault("sinkName")
  valid_589325 = validateParameter(valid_589325, JString, required = true,
                                 default = nil)
  if valid_589325 != nil:
    section.add "sinkName", valid_589325
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
  var valid_589326 = query.getOrDefault("upload_protocol")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = nil)
  if valid_589326 != nil:
    section.add "upload_protocol", valid_589326
  var valid_589327 = query.getOrDefault("fields")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "fields", valid_589327
  var valid_589328 = query.getOrDefault("quotaUser")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "quotaUser", valid_589328
  var valid_589329 = query.getOrDefault("alt")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = newJString("json"))
  if valid_589329 != nil:
    section.add "alt", valid_589329
  var valid_589330 = query.getOrDefault("oauth_token")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "oauth_token", valid_589330
  var valid_589331 = query.getOrDefault("callback")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "callback", valid_589331
  var valid_589332 = query.getOrDefault("access_token")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "access_token", valid_589332
  var valid_589333 = query.getOrDefault("uploadType")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = nil)
  if valid_589333 != nil:
    section.add "uploadType", valid_589333
  var valid_589334 = query.getOrDefault("key")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "key", valid_589334
  var valid_589335 = query.getOrDefault("$.xgafv")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = newJString("1"))
  if valid_589335 != nil:
    section.add "$.xgafv", valid_589335
  var valid_589336 = query.getOrDefault("prettyPrint")
  valid_589336 = validateParameter(valid_589336, JBool, required = false,
                                 default = newJBool(true))
  if valid_589336 != nil:
    section.add "prettyPrint", valid_589336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589337: Call_LoggingOrganizationsSinksGet_589322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a sink.
  ## 
  let valid = call_589337.validator(path, query, header, formData, body)
  let scheme = call_589337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589337.url(scheme.get, call_589337.host, call_589337.base,
                         call_589337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589337, url, valid)

proc call*(call_589338: Call_LoggingOrganizationsSinksGet_589322; sinkName: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## loggingOrganizationsSinksGet
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
  var path_589339 = newJObject()
  var query_589340 = newJObject()
  add(query_589340, "upload_protocol", newJString(uploadProtocol))
  add(query_589340, "fields", newJString(fields))
  add(query_589340, "quotaUser", newJString(quotaUser))
  add(path_589339, "sinkName", newJString(sinkName))
  add(query_589340, "alt", newJString(alt))
  add(query_589340, "oauth_token", newJString(oauthToken))
  add(query_589340, "callback", newJString(callback))
  add(query_589340, "access_token", newJString(accessToken))
  add(query_589340, "uploadType", newJString(uploadType))
  add(query_589340, "key", newJString(key))
  add(query_589340, "$.xgafv", newJString(Xgafv))
  add(query_589340, "prettyPrint", newJBool(prettyPrint))
  result = call_589338.call(path_589339, query_589340, nil, nil, nil)

var loggingOrganizationsSinksGet* = Call_LoggingOrganizationsSinksGet_589322(
    name: "loggingOrganizationsSinksGet", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{sinkName}",
    validator: validate_LoggingOrganizationsSinksGet_589323, base: "/",
    url: url_LoggingOrganizationsSinksGet_589324, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsSinksPatch_589383 = ref object of OpenApiRestCall_588441
proc url_LoggingOrganizationsSinksPatch_589385(protocol: Scheme; host: string;
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

proc validate_LoggingOrganizationsSinksPatch_589384(path: JsonNode;
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
  var valid_589386 = path.getOrDefault("sinkName")
  valid_589386 = validateParameter(valid_589386, JString, required = true,
                                 default = nil)
  if valid_589386 != nil:
    section.add "sinkName", valid_589386
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
  var valid_589387 = query.getOrDefault("upload_protocol")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "upload_protocol", valid_589387
  var valid_589388 = query.getOrDefault("fields")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "fields", valid_589388
  var valid_589389 = query.getOrDefault("quotaUser")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = nil)
  if valid_589389 != nil:
    section.add "quotaUser", valid_589389
  var valid_589390 = query.getOrDefault("alt")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = newJString("json"))
  if valid_589390 != nil:
    section.add "alt", valid_589390
  var valid_589391 = query.getOrDefault("uniqueWriterIdentity")
  valid_589391 = validateParameter(valid_589391, JBool, required = false, default = nil)
  if valid_589391 != nil:
    section.add "uniqueWriterIdentity", valid_589391
  var valid_589392 = query.getOrDefault("oauth_token")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = nil)
  if valid_589392 != nil:
    section.add "oauth_token", valid_589392
  var valid_589393 = query.getOrDefault("callback")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = nil)
  if valid_589393 != nil:
    section.add "callback", valid_589393
  var valid_589394 = query.getOrDefault("access_token")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "access_token", valid_589394
  var valid_589395 = query.getOrDefault("uploadType")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = nil)
  if valid_589395 != nil:
    section.add "uploadType", valid_589395
  var valid_589396 = query.getOrDefault("key")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = nil)
  if valid_589396 != nil:
    section.add "key", valid_589396
  var valid_589397 = query.getOrDefault("$.xgafv")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = newJString("1"))
  if valid_589397 != nil:
    section.add "$.xgafv", valid_589397
  var valid_589398 = query.getOrDefault("prettyPrint")
  valid_589398 = validateParameter(valid_589398, JBool, required = false,
                                 default = newJBool(true))
  if valid_589398 != nil:
    section.add "prettyPrint", valid_589398
  var valid_589399 = query.getOrDefault("updateMask")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = nil)
  if valid_589399 != nil:
    section.add "updateMask", valid_589399
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

proc call*(call_589401: Call_LoggingOrganizationsSinksPatch_589383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a sink. This method replaces the following fields in the existing sink with values from the new sink: destination, and filter.The updated sink might also have a new writer_identity; see the unique_writer_identity field.
  ## 
  let valid = call_589401.validator(path, query, header, formData, body)
  let scheme = call_589401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589401.url(scheme.get, call_589401.host, call_589401.base,
                         call_589401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589401, url, valid)

proc call*(call_589402: Call_LoggingOrganizationsSinksPatch_589383;
          sinkName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          uniqueWriterIdentity: bool = false; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## loggingOrganizationsSinksPatch
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
  var path_589403 = newJObject()
  var query_589404 = newJObject()
  var body_589405 = newJObject()
  add(query_589404, "upload_protocol", newJString(uploadProtocol))
  add(query_589404, "fields", newJString(fields))
  add(query_589404, "quotaUser", newJString(quotaUser))
  add(path_589403, "sinkName", newJString(sinkName))
  add(query_589404, "alt", newJString(alt))
  add(query_589404, "uniqueWriterIdentity", newJBool(uniqueWriterIdentity))
  add(query_589404, "oauth_token", newJString(oauthToken))
  add(query_589404, "callback", newJString(callback))
  add(query_589404, "access_token", newJString(accessToken))
  add(query_589404, "uploadType", newJString(uploadType))
  add(query_589404, "key", newJString(key))
  add(query_589404, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589405 = body
  add(query_589404, "prettyPrint", newJBool(prettyPrint))
  add(query_589404, "updateMask", newJString(updateMask))
  result = call_589402.call(path_589403, query_589404, nil, nil, body_589405)

var loggingOrganizationsSinksPatch* = Call_LoggingOrganizationsSinksPatch_589383(
    name: "loggingOrganizationsSinksPatch", meth: HttpMethod.HttpPatch,
    host: "logging.googleapis.com", route: "/v2/{sinkName}",
    validator: validate_LoggingOrganizationsSinksPatch_589384, base: "/",
    url: url_LoggingOrganizationsSinksPatch_589385, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsSinksDelete_589364 = ref object of OpenApiRestCall_588441
proc url_LoggingOrganizationsSinksDelete_589366(protocol: Scheme; host: string;
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

proc validate_LoggingOrganizationsSinksDelete_589365(path: JsonNode;
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
  var valid_589367 = path.getOrDefault("sinkName")
  valid_589367 = validateParameter(valid_589367, JString, required = true,
                                 default = nil)
  if valid_589367 != nil:
    section.add "sinkName", valid_589367
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
  var valid_589368 = query.getOrDefault("upload_protocol")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = nil)
  if valid_589368 != nil:
    section.add "upload_protocol", valid_589368
  var valid_589369 = query.getOrDefault("fields")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = nil)
  if valid_589369 != nil:
    section.add "fields", valid_589369
  var valid_589370 = query.getOrDefault("quotaUser")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "quotaUser", valid_589370
  var valid_589371 = query.getOrDefault("alt")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = newJString("json"))
  if valid_589371 != nil:
    section.add "alt", valid_589371
  var valid_589372 = query.getOrDefault("oauth_token")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "oauth_token", valid_589372
  var valid_589373 = query.getOrDefault("callback")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "callback", valid_589373
  var valid_589374 = query.getOrDefault("access_token")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "access_token", valid_589374
  var valid_589375 = query.getOrDefault("uploadType")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = nil)
  if valid_589375 != nil:
    section.add "uploadType", valid_589375
  var valid_589376 = query.getOrDefault("key")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = nil)
  if valid_589376 != nil:
    section.add "key", valid_589376
  var valid_589377 = query.getOrDefault("$.xgafv")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = newJString("1"))
  if valid_589377 != nil:
    section.add "$.xgafv", valid_589377
  var valid_589378 = query.getOrDefault("prettyPrint")
  valid_589378 = validateParameter(valid_589378, JBool, required = false,
                                 default = newJBool(true))
  if valid_589378 != nil:
    section.add "prettyPrint", valid_589378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589379: Call_LoggingOrganizationsSinksDelete_589364;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a sink. If the sink has a unique writer_identity, then that service account is also deleted.
  ## 
  let valid = call_589379.validator(path, query, header, formData, body)
  let scheme = call_589379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589379.url(scheme.get, call_589379.host, call_589379.base,
                         call_589379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589379, url, valid)

proc call*(call_589380: Call_LoggingOrganizationsSinksDelete_589364;
          sinkName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## loggingOrganizationsSinksDelete
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
  var path_589381 = newJObject()
  var query_589382 = newJObject()
  add(query_589382, "upload_protocol", newJString(uploadProtocol))
  add(query_589382, "fields", newJString(fields))
  add(query_589382, "quotaUser", newJString(quotaUser))
  add(path_589381, "sinkName", newJString(sinkName))
  add(query_589382, "alt", newJString(alt))
  add(query_589382, "oauth_token", newJString(oauthToken))
  add(query_589382, "callback", newJString(callback))
  add(query_589382, "access_token", newJString(accessToken))
  add(query_589382, "uploadType", newJString(uploadType))
  add(query_589382, "key", newJString(key))
  add(query_589382, "$.xgafv", newJString(Xgafv))
  add(query_589382, "prettyPrint", newJBool(prettyPrint))
  result = call_589380.call(path_589381, query_589382, nil, nil, nil)

var loggingOrganizationsSinksDelete* = Call_LoggingOrganizationsSinksDelete_589364(
    name: "loggingOrganizationsSinksDelete", meth: HttpMethod.HttpDelete,
    host: "logging.googleapis.com", route: "/v2/{sinkName}",
    validator: validate_LoggingOrganizationsSinksDelete_589365, base: "/",
    url: url_LoggingOrganizationsSinksDelete_589366, schemes: {Scheme.Https})
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
