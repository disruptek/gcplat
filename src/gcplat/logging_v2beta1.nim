
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Stackdriver Logging
## version: v2beta1
## termsOfService: (not provided)
## license: (not provided)
## 
## Writes log entries and manages your Logging configuration.
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
    host: "logging.googleapis.com", route: "/v2beta1/entries:list",
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
    host: "logging.googleapis.com", route: "/v2beta1/entries:write",
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
    host: "logging.googleapis.com",
    route: "/v2beta1/monitoredResourceDescriptors",
    validator: validate_LoggingMonitoredResourceDescriptorsList_589004, base: "/",
    url: url_LoggingMonitoredResourceDescriptorsList_589005,
    schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsUpdate_589055 = ref object of OpenApiRestCall_588441
proc url_LoggingProjectsMetricsUpdate_589057(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "metricName" in path, "`metricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "metricName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingProjectsMetricsUpdate_589056(path: JsonNode; query: JsonNode;
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589071: Call_LoggingProjectsMetricsUpdate_589055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a logs-based metric.
  ## 
  let valid = call_589071.validator(path, query, header, formData, body)
  let scheme = call_589071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589071.url(scheme.get, call_589071.host, call_589071.base,
                         call_589071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589071, url, valid)

proc call*(call_589072: Call_LoggingProjectsMetricsUpdate_589055;
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
  var path_589073 = newJObject()
  var query_589074 = newJObject()
  var body_589075 = newJObject()
  add(query_589074, "upload_protocol", newJString(uploadProtocol))
  add(query_589074, "fields", newJString(fields))
  add(query_589074, "quotaUser", newJString(quotaUser))
  add(query_589074, "alt", newJString(alt))
  add(query_589074, "oauth_token", newJString(oauthToken))
  add(query_589074, "callback", newJString(callback))
  add(query_589074, "access_token", newJString(accessToken))
  add(query_589074, "uploadType", newJString(uploadType))
  add(path_589073, "metricName", newJString(metricName))
  add(query_589074, "key", newJString(key))
  add(query_589074, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589075 = body
  add(query_589074, "prettyPrint", newJBool(prettyPrint))
  result = call_589072.call(path_589073, query_589074, nil, nil, body_589075)

var loggingProjectsMetricsUpdate* = Call_LoggingProjectsMetricsUpdate_589055(
    name: "loggingProjectsMetricsUpdate", meth: HttpMethod.HttpPut,
    host: "logging.googleapis.com", route: "/v2beta1/{metricName}",
    validator: validate_LoggingProjectsMetricsUpdate_589056, base: "/",
    url: url_LoggingProjectsMetricsUpdate_589057, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsGet_589022 = ref object of OpenApiRestCall_588441
proc url_LoggingProjectsMetricsGet_589024(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "metricName" in path, "`metricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "metricName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingProjectsMetricsGet_589023(path: JsonNode; query: JsonNode;
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
  var valid_589039 = path.getOrDefault("metricName")
  valid_589039 = validateParameter(valid_589039, JString, required = true,
                                 default = nil)
  if valid_589039 != nil:
    section.add "metricName", valid_589039
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

proc call*(call_589051: Call_LoggingProjectsMetricsGet_589022; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a logs-based metric.
  ## 
  let valid = call_589051.validator(path, query, header, formData, body)
  let scheme = call_589051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589051.url(scheme.get, call_589051.host, call_589051.base,
                         call_589051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589051, url, valid)

proc call*(call_589052: Call_LoggingProjectsMetricsGet_589022; metricName: string;
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
  add(path_589053, "metricName", newJString(metricName))
  add(query_589054, "key", newJString(key))
  add(query_589054, "$.xgafv", newJString(Xgafv))
  add(query_589054, "prettyPrint", newJBool(prettyPrint))
  result = call_589052.call(path_589053, query_589054, nil, nil, nil)

var loggingProjectsMetricsGet* = Call_LoggingProjectsMetricsGet_589022(
    name: "loggingProjectsMetricsGet", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2beta1/{metricName}",
    validator: validate_LoggingProjectsMetricsGet_589023, base: "/",
    url: url_LoggingProjectsMetricsGet_589024, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsDelete_589076 = ref object of OpenApiRestCall_588441
proc url_LoggingProjectsMetricsDelete_589078(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "metricName" in path, "`metricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "metricName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingProjectsMetricsDelete_589077(path: JsonNode; query: JsonNode;
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
  var valid_589079 = path.getOrDefault("metricName")
  valid_589079 = validateParameter(valid_589079, JString, required = true,
                                 default = nil)
  if valid_589079 != nil:
    section.add "metricName", valid_589079
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
  var valid_589080 = query.getOrDefault("upload_protocol")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "upload_protocol", valid_589080
  var valid_589081 = query.getOrDefault("fields")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "fields", valid_589081
  var valid_589082 = query.getOrDefault("quotaUser")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "quotaUser", valid_589082
  var valid_589083 = query.getOrDefault("alt")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = newJString("json"))
  if valid_589083 != nil:
    section.add "alt", valid_589083
  var valid_589084 = query.getOrDefault("oauth_token")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "oauth_token", valid_589084
  var valid_589085 = query.getOrDefault("callback")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "callback", valid_589085
  var valid_589086 = query.getOrDefault("access_token")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "access_token", valid_589086
  var valid_589087 = query.getOrDefault("uploadType")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "uploadType", valid_589087
  var valid_589088 = query.getOrDefault("key")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "key", valid_589088
  var valid_589089 = query.getOrDefault("$.xgafv")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = newJString("1"))
  if valid_589089 != nil:
    section.add "$.xgafv", valid_589089
  var valid_589090 = query.getOrDefault("prettyPrint")
  valid_589090 = validateParameter(valid_589090, JBool, required = false,
                                 default = newJBool(true))
  if valid_589090 != nil:
    section.add "prettyPrint", valid_589090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589091: Call_LoggingProjectsMetricsDelete_589076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a logs-based metric.
  ## 
  let valid = call_589091.validator(path, query, header, formData, body)
  let scheme = call_589091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589091.url(scheme.get, call_589091.host, call_589091.base,
                         call_589091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589091, url, valid)

proc call*(call_589092: Call_LoggingProjectsMetricsDelete_589076;
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
  var path_589093 = newJObject()
  var query_589094 = newJObject()
  add(query_589094, "upload_protocol", newJString(uploadProtocol))
  add(query_589094, "fields", newJString(fields))
  add(query_589094, "quotaUser", newJString(quotaUser))
  add(query_589094, "alt", newJString(alt))
  add(query_589094, "oauth_token", newJString(oauthToken))
  add(query_589094, "callback", newJString(callback))
  add(query_589094, "access_token", newJString(accessToken))
  add(query_589094, "uploadType", newJString(uploadType))
  add(path_589093, "metricName", newJString(metricName))
  add(query_589094, "key", newJString(key))
  add(query_589094, "$.xgafv", newJString(Xgafv))
  add(query_589094, "prettyPrint", newJBool(prettyPrint))
  result = call_589092.call(path_589093, query_589094, nil, nil, nil)

var loggingProjectsMetricsDelete* = Call_LoggingProjectsMetricsDelete_589076(
    name: "loggingProjectsMetricsDelete", meth: HttpMethod.HttpDelete,
    host: "logging.googleapis.com", route: "/v2beta1/{metricName}",
    validator: validate_LoggingProjectsMetricsDelete_589077, base: "/",
    url: url_LoggingProjectsMetricsDelete_589078, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsCreate_589116 = ref object of OpenApiRestCall_588441
proc url_LoggingProjectsMetricsCreate_589118(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingProjectsMetricsCreate_589117(path: JsonNode; query: JsonNode;
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
  var valid_589119 = path.getOrDefault("parent")
  valid_589119 = validateParameter(valid_589119, JString, required = true,
                                 default = nil)
  if valid_589119 != nil:
    section.add "parent", valid_589119
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
  var valid_589120 = query.getOrDefault("upload_protocol")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "upload_protocol", valid_589120
  var valid_589121 = query.getOrDefault("fields")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "fields", valid_589121
  var valid_589122 = query.getOrDefault("quotaUser")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "quotaUser", valid_589122
  var valid_589123 = query.getOrDefault("alt")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = newJString("json"))
  if valid_589123 != nil:
    section.add "alt", valid_589123
  var valid_589124 = query.getOrDefault("oauth_token")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "oauth_token", valid_589124
  var valid_589125 = query.getOrDefault("callback")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "callback", valid_589125
  var valid_589126 = query.getOrDefault("access_token")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "access_token", valid_589126
  var valid_589127 = query.getOrDefault("uploadType")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "uploadType", valid_589127
  var valid_589128 = query.getOrDefault("key")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "key", valid_589128
  var valid_589129 = query.getOrDefault("$.xgafv")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = newJString("1"))
  if valid_589129 != nil:
    section.add "$.xgafv", valid_589129
  var valid_589130 = query.getOrDefault("prettyPrint")
  valid_589130 = validateParameter(valid_589130, JBool, required = false,
                                 default = newJBool(true))
  if valid_589130 != nil:
    section.add "prettyPrint", valid_589130
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

proc call*(call_589132: Call_LoggingProjectsMetricsCreate_589116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a logs-based metric.
  ## 
  let valid = call_589132.validator(path, query, header, formData, body)
  let scheme = call_589132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589132.url(scheme.get, call_589132.host, call_589132.base,
                         call_589132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589132, url, valid)

proc call*(call_589133: Call_LoggingProjectsMetricsCreate_589116; parent: string;
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
  var path_589134 = newJObject()
  var query_589135 = newJObject()
  var body_589136 = newJObject()
  add(query_589135, "upload_protocol", newJString(uploadProtocol))
  add(query_589135, "fields", newJString(fields))
  add(query_589135, "quotaUser", newJString(quotaUser))
  add(query_589135, "alt", newJString(alt))
  add(query_589135, "oauth_token", newJString(oauthToken))
  add(query_589135, "callback", newJString(callback))
  add(query_589135, "access_token", newJString(accessToken))
  add(query_589135, "uploadType", newJString(uploadType))
  add(path_589134, "parent", newJString(parent))
  add(query_589135, "key", newJString(key))
  add(query_589135, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589136 = body
  add(query_589135, "prettyPrint", newJBool(prettyPrint))
  result = call_589133.call(path_589134, query_589135, nil, nil, body_589136)

var loggingProjectsMetricsCreate* = Call_LoggingProjectsMetricsCreate_589116(
    name: "loggingProjectsMetricsCreate", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2beta1/{parent}/metrics",
    validator: validate_LoggingProjectsMetricsCreate_589117, base: "/",
    url: url_LoggingProjectsMetricsCreate_589118, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsList_589095 = ref object of OpenApiRestCall_588441
proc url_LoggingProjectsMetricsList_589097(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingProjectsMetricsList_589096(path: JsonNode; query: JsonNode;
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
  var valid_589098 = path.getOrDefault("parent")
  valid_589098 = validateParameter(valid_589098, JString, required = true,
                                 default = nil)
  if valid_589098 != nil:
    section.add "parent", valid_589098
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
  var valid_589101 = query.getOrDefault("pageToken")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "pageToken", valid_589101
  var valid_589102 = query.getOrDefault("quotaUser")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "quotaUser", valid_589102
  var valid_589103 = query.getOrDefault("alt")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = newJString("json"))
  if valid_589103 != nil:
    section.add "alt", valid_589103
  var valid_589104 = query.getOrDefault("oauth_token")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "oauth_token", valid_589104
  var valid_589105 = query.getOrDefault("callback")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "callback", valid_589105
  var valid_589106 = query.getOrDefault("access_token")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "access_token", valid_589106
  var valid_589107 = query.getOrDefault("uploadType")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "uploadType", valid_589107
  var valid_589108 = query.getOrDefault("key")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "key", valid_589108
  var valid_589109 = query.getOrDefault("$.xgafv")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = newJString("1"))
  if valid_589109 != nil:
    section.add "$.xgafv", valid_589109
  var valid_589110 = query.getOrDefault("pageSize")
  valid_589110 = validateParameter(valid_589110, JInt, required = false, default = nil)
  if valid_589110 != nil:
    section.add "pageSize", valid_589110
  var valid_589111 = query.getOrDefault("prettyPrint")
  valid_589111 = validateParameter(valid_589111, JBool, required = false,
                                 default = newJBool(true))
  if valid_589111 != nil:
    section.add "prettyPrint", valid_589111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589112: Call_LoggingProjectsMetricsList_589095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists logs-based metrics.
  ## 
  let valid = call_589112.validator(path, query, header, formData, body)
  let scheme = call_589112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589112.url(scheme.get, call_589112.host, call_589112.base,
                         call_589112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589112, url, valid)

proc call*(call_589113: Call_LoggingProjectsMetricsList_589095; parent: string;
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
  var path_589114 = newJObject()
  var query_589115 = newJObject()
  add(query_589115, "upload_protocol", newJString(uploadProtocol))
  add(query_589115, "fields", newJString(fields))
  add(query_589115, "pageToken", newJString(pageToken))
  add(query_589115, "quotaUser", newJString(quotaUser))
  add(query_589115, "alt", newJString(alt))
  add(query_589115, "oauth_token", newJString(oauthToken))
  add(query_589115, "callback", newJString(callback))
  add(query_589115, "access_token", newJString(accessToken))
  add(query_589115, "uploadType", newJString(uploadType))
  add(path_589114, "parent", newJString(parent))
  add(query_589115, "key", newJString(key))
  add(query_589115, "$.xgafv", newJString(Xgafv))
  add(query_589115, "pageSize", newJInt(pageSize))
  add(query_589115, "prettyPrint", newJBool(prettyPrint))
  result = call_589113.call(path_589114, query_589115, nil, nil, nil)

var loggingProjectsMetricsList* = Call_LoggingProjectsMetricsList_589095(
    name: "loggingProjectsMetricsList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2beta1/{parent}/metrics",
    validator: validate_LoggingProjectsMetricsList_589096, base: "/",
    url: url_LoggingProjectsMetricsList_589097, schemes: {Scheme.Https})
type
  Call_LoggingProjectsSinksCreate_589158 = ref object of OpenApiRestCall_588441
proc url_LoggingProjectsSinksCreate_589160(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/sinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingProjectsSinksCreate_589159(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_589161 = path.getOrDefault("parent")
  valid_589161 = validateParameter(valid_589161, JString, required = true,
                                 default = nil)
  if valid_589161 != nil:
    section.add "parent", valid_589161
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
  var valid_589162 = query.getOrDefault("upload_protocol")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "upload_protocol", valid_589162
  var valid_589163 = query.getOrDefault("fields")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "fields", valid_589163
  var valid_589164 = query.getOrDefault("quotaUser")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "quotaUser", valid_589164
  var valid_589165 = query.getOrDefault("alt")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = newJString("json"))
  if valid_589165 != nil:
    section.add "alt", valid_589165
  var valid_589166 = query.getOrDefault("uniqueWriterIdentity")
  valid_589166 = validateParameter(valid_589166, JBool, required = false, default = nil)
  if valid_589166 != nil:
    section.add "uniqueWriterIdentity", valid_589166
  var valid_589167 = query.getOrDefault("oauth_token")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "oauth_token", valid_589167
  var valid_589168 = query.getOrDefault("callback")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "callback", valid_589168
  var valid_589169 = query.getOrDefault("access_token")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "access_token", valid_589169
  var valid_589170 = query.getOrDefault("uploadType")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "uploadType", valid_589170
  var valid_589171 = query.getOrDefault("key")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "key", valid_589171
  var valid_589172 = query.getOrDefault("$.xgafv")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = newJString("1"))
  if valid_589172 != nil:
    section.add "$.xgafv", valid_589172
  var valid_589173 = query.getOrDefault("prettyPrint")
  valid_589173 = validateParameter(valid_589173, JBool, required = false,
                                 default = newJBool(true))
  if valid_589173 != nil:
    section.add "prettyPrint", valid_589173
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

proc call*(call_589175: Call_LoggingProjectsSinksCreate_589158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a sink that exports specified log entries to a destination. The export of newly-ingested log entries begins immediately, unless the sink's writer_identity is not permitted to write to the destination. A sink can export log entries only from the resource owning the sink.
  ## 
  let valid = call_589175.validator(path, query, header, formData, body)
  let scheme = call_589175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589175.url(scheme.get, call_589175.host, call_589175.base,
                         call_589175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589175, url, valid)

proc call*(call_589176: Call_LoggingProjectsSinksCreate_589158; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; uniqueWriterIdentity: bool = false;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## loggingProjectsSinksCreate
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
  var path_589177 = newJObject()
  var query_589178 = newJObject()
  var body_589179 = newJObject()
  add(query_589178, "upload_protocol", newJString(uploadProtocol))
  add(query_589178, "fields", newJString(fields))
  add(query_589178, "quotaUser", newJString(quotaUser))
  add(query_589178, "alt", newJString(alt))
  add(query_589178, "uniqueWriterIdentity", newJBool(uniqueWriterIdentity))
  add(query_589178, "oauth_token", newJString(oauthToken))
  add(query_589178, "callback", newJString(callback))
  add(query_589178, "access_token", newJString(accessToken))
  add(query_589178, "uploadType", newJString(uploadType))
  add(path_589177, "parent", newJString(parent))
  add(query_589178, "key", newJString(key))
  add(query_589178, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589179 = body
  add(query_589178, "prettyPrint", newJBool(prettyPrint))
  result = call_589176.call(path_589177, query_589178, nil, nil, body_589179)

var loggingProjectsSinksCreate* = Call_LoggingProjectsSinksCreate_589158(
    name: "loggingProjectsSinksCreate", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2beta1/{parent}/sinks",
    validator: validate_LoggingProjectsSinksCreate_589159, base: "/",
    url: url_LoggingProjectsSinksCreate_589160, schemes: {Scheme.Https})
type
  Call_LoggingProjectsSinksList_589137 = ref object of OpenApiRestCall_588441
proc url_LoggingProjectsSinksList_589139(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/sinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingProjectsSinksList_589138(path: JsonNode; query: JsonNode;
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
  var valid_589140 = path.getOrDefault("parent")
  valid_589140 = validateParameter(valid_589140, JString, required = true,
                                 default = nil)
  if valid_589140 != nil:
    section.add "parent", valid_589140
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
  var valid_589141 = query.getOrDefault("upload_protocol")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "upload_protocol", valid_589141
  var valid_589142 = query.getOrDefault("fields")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "fields", valid_589142
  var valid_589143 = query.getOrDefault("pageToken")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "pageToken", valid_589143
  var valid_589144 = query.getOrDefault("quotaUser")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "quotaUser", valid_589144
  var valid_589145 = query.getOrDefault("alt")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = newJString("json"))
  if valid_589145 != nil:
    section.add "alt", valid_589145
  var valid_589146 = query.getOrDefault("oauth_token")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "oauth_token", valid_589146
  var valid_589147 = query.getOrDefault("callback")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "callback", valid_589147
  var valid_589148 = query.getOrDefault("access_token")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "access_token", valid_589148
  var valid_589149 = query.getOrDefault("uploadType")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "uploadType", valid_589149
  var valid_589150 = query.getOrDefault("key")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "key", valid_589150
  var valid_589151 = query.getOrDefault("$.xgafv")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = newJString("1"))
  if valid_589151 != nil:
    section.add "$.xgafv", valid_589151
  var valid_589152 = query.getOrDefault("pageSize")
  valid_589152 = validateParameter(valid_589152, JInt, required = false, default = nil)
  if valid_589152 != nil:
    section.add "pageSize", valid_589152
  var valid_589153 = query.getOrDefault("prettyPrint")
  valid_589153 = validateParameter(valid_589153, JBool, required = false,
                                 default = newJBool(true))
  if valid_589153 != nil:
    section.add "prettyPrint", valid_589153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589154: Call_LoggingProjectsSinksList_589137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists sinks.
  ## 
  let valid = call_589154.validator(path, query, header, formData, body)
  let scheme = call_589154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589154.url(scheme.get, call_589154.host, call_589154.base,
                         call_589154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589154, url, valid)

proc call*(call_589155: Call_LoggingProjectsSinksList_589137; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## loggingProjectsSinksList
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
  var path_589156 = newJObject()
  var query_589157 = newJObject()
  add(query_589157, "upload_protocol", newJString(uploadProtocol))
  add(query_589157, "fields", newJString(fields))
  add(query_589157, "pageToken", newJString(pageToken))
  add(query_589157, "quotaUser", newJString(quotaUser))
  add(query_589157, "alt", newJString(alt))
  add(query_589157, "oauth_token", newJString(oauthToken))
  add(query_589157, "callback", newJString(callback))
  add(query_589157, "access_token", newJString(accessToken))
  add(query_589157, "uploadType", newJString(uploadType))
  add(path_589156, "parent", newJString(parent))
  add(query_589157, "key", newJString(key))
  add(query_589157, "$.xgafv", newJString(Xgafv))
  add(query_589157, "pageSize", newJInt(pageSize))
  add(query_589157, "prettyPrint", newJBool(prettyPrint))
  result = call_589155.call(path_589156, query_589157, nil, nil, nil)

var loggingProjectsSinksList* = Call_LoggingProjectsSinksList_589137(
    name: "loggingProjectsSinksList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2beta1/{parent}/sinks",
    validator: validate_LoggingProjectsSinksList_589138, base: "/",
    url: url_LoggingProjectsSinksList_589139, schemes: {Scheme.Https})
type
  Call_LoggingProjectsSinksUpdate_589199 = ref object of OpenApiRestCall_588441
proc url_LoggingProjectsSinksUpdate_589201(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "sinkName" in path, "`sinkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "sinkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingProjectsSinksUpdate_589200(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_589202 = path.getOrDefault("sinkName")
  valid_589202 = validateParameter(valid_589202, JString, required = true,
                                 default = nil)
  if valid_589202 != nil:
    section.add "sinkName", valid_589202
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
  var valid_589203 = query.getOrDefault("upload_protocol")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "upload_protocol", valid_589203
  var valid_589204 = query.getOrDefault("fields")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "fields", valid_589204
  var valid_589205 = query.getOrDefault("quotaUser")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "quotaUser", valid_589205
  var valid_589206 = query.getOrDefault("alt")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = newJString("json"))
  if valid_589206 != nil:
    section.add "alt", valid_589206
  var valid_589207 = query.getOrDefault("uniqueWriterIdentity")
  valid_589207 = validateParameter(valid_589207, JBool, required = false, default = nil)
  if valid_589207 != nil:
    section.add "uniqueWriterIdentity", valid_589207
  var valid_589208 = query.getOrDefault("oauth_token")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "oauth_token", valid_589208
  var valid_589209 = query.getOrDefault("callback")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "callback", valid_589209
  var valid_589210 = query.getOrDefault("access_token")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "access_token", valid_589210
  var valid_589211 = query.getOrDefault("uploadType")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "uploadType", valid_589211
  var valid_589212 = query.getOrDefault("key")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "key", valid_589212
  var valid_589213 = query.getOrDefault("$.xgafv")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = newJString("1"))
  if valid_589213 != nil:
    section.add "$.xgafv", valid_589213
  var valid_589214 = query.getOrDefault("prettyPrint")
  valid_589214 = validateParameter(valid_589214, JBool, required = false,
                                 default = newJBool(true))
  if valid_589214 != nil:
    section.add "prettyPrint", valid_589214
  var valid_589215 = query.getOrDefault("updateMask")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "updateMask", valid_589215
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

proc call*(call_589217: Call_LoggingProjectsSinksUpdate_589199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a sink. This method replaces the following fields in the existing sink with values from the new sink: destination, and filter.The updated sink might also have a new writer_identity; see the unique_writer_identity field.
  ## 
  let valid = call_589217.validator(path, query, header, formData, body)
  let scheme = call_589217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589217.url(scheme.get, call_589217.host, call_589217.base,
                         call_589217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589217, url, valid)

proc call*(call_589218: Call_LoggingProjectsSinksUpdate_589199; sinkName: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; uniqueWriterIdentity: bool = false;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## loggingProjectsSinksUpdate
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
  var path_589219 = newJObject()
  var query_589220 = newJObject()
  var body_589221 = newJObject()
  add(query_589220, "upload_protocol", newJString(uploadProtocol))
  add(query_589220, "fields", newJString(fields))
  add(query_589220, "quotaUser", newJString(quotaUser))
  add(path_589219, "sinkName", newJString(sinkName))
  add(query_589220, "alt", newJString(alt))
  add(query_589220, "uniqueWriterIdentity", newJBool(uniqueWriterIdentity))
  add(query_589220, "oauth_token", newJString(oauthToken))
  add(query_589220, "callback", newJString(callback))
  add(query_589220, "access_token", newJString(accessToken))
  add(query_589220, "uploadType", newJString(uploadType))
  add(query_589220, "key", newJString(key))
  add(query_589220, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589221 = body
  add(query_589220, "prettyPrint", newJBool(prettyPrint))
  add(query_589220, "updateMask", newJString(updateMask))
  result = call_589218.call(path_589219, query_589220, nil, nil, body_589221)

var loggingProjectsSinksUpdate* = Call_LoggingProjectsSinksUpdate_589199(
    name: "loggingProjectsSinksUpdate", meth: HttpMethod.HttpPut,
    host: "logging.googleapis.com", route: "/v2beta1/{sinkName}",
    validator: validate_LoggingProjectsSinksUpdate_589200, base: "/",
    url: url_LoggingProjectsSinksUpdate_589201, schemes: {Scheme.Https})
type
  Call_LoggingProjectsSinksGet_589180 = ref object of OpenApiRestCall_588441
proc url_LoggingProjectsSinksGet_589182(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "sinkName" in path, "`sinkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "sinkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingProjectsSinksGet_589181(path: JsonNode; query: JsonNode;
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
  var valid_589183 = path.getOrDefault("sinkName")
  valid_589183 = validateParameter(valid_589183, JString, required = true,
                                 default = nil)
  if valid_589183 != nil:
    section.add "sinkName", valid_589183
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
  var valid_589184 = query.getOrDefault("upload_protocol")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "upload_protocol", valid_589184
  var valid_589185 = query.getOrDefault("fields")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "fields", valid_589185
  var valid_589186 = query.getOrDefault("quotaUser")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "quotaUser", valid_589186
  var valid_589187 = query.getOrDefault("alt")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = newJString("json"))
  if valid_589187 != nil:
    section.add "alt", valid_589187
  var valid_589188 = query.getOrDefault("oauth_token")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "oauth_token", valid_589188
  var valid_589189 = query.getOrDefault("callback")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "callback", valid_589189
  var valid_589190 = query.getOrDefault("access_token")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "access_token", valid_589190
  var valid_589191 = query.getOrDefault("uploadType")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "uploadType", valid_589191
  var valid_589192 = query.getOrDefault("key")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "key", valid_589192
  var valid_589193 = query.getOrDefault("$.xgafv")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = newJString("1"))
  if valid_589193 != nil:
    section.add "$.xgafv", valid_589193
  var valid_589194 = query.getOrDefault("prettyPrint")
  valid_589194 = validateParameter(valid_589194, JBool, required = false,
                                 default = newJBool(true))
  if valid_589194 != nil:
    section.add "prettyPrint", valid_589194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589195: Call_LoggingProjectsSinksGet_589180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a sink.
  ## 
  let valid = call_589195.validator(path, query, header, formData, body)
  let scheme = call_589195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589195.url(scheme.get, call_589195.host, call_589195.base,
                         call_589195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589195, url, valid)

proc call*(call_589196: Call_LoggingProjectsSinksGet_589180; sinkName: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## loggingProjectsSinksGet
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
  var path_589197 = newJObject()
  var query_589198 = newJObject()
  add(query_589198, "upload_protocol", newJString(uploadProtocol))
  add(query_589198, "fields", newJString(fields))
  add(query_589198, "quotaUser", newJString(quotaUser))
  add(path_589197, "sinkName", newJString(sinkName))
  add(query_589198, "alt", newJString(alt))
  add(query_589198, "oauth_token", newJString(oauthToken))
  add(query_589198, "callback", newJString(callback))
  add(query_589198, "access_token", newJString(accessToken))
  add(query_589198, "uploadType", newJString(uploadType))
  add(query_589198, "key", newJString(key))
  add(query_589198, "$.xgafv", newJString(Xgafv))
  add(query_589198, "prettyPrint", newJBool(prettyPrint))
  result = call_589196.call(path_589197, query_589198, nil, nil, nil)

var loggingProjectsSinksGet* = Call_LoggingProjectsSinksGet_589180(
    name: "loggingProjectsSinksGet", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2beta1/{sinkName}",
    validator: validate_LoggingProjectsSinksGet_589181, base: "/",
    url: url_LoggingProjectsSinksGet_589182, schemes: {Scheme.Https})
type
  Call_LoggingProjectsSinksDelete_589222 = ref object of OpenApiRestCall_588441
proc url_LoggingProjectsSinksDelete_589224(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "sinkName" in path, "`sinkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "sinkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggingProjectsSinksDelete_589223(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_589225 = path.getOrDefault("sinkName")
  valid_589225 = validateParameter(valid_589225, JString, required = true,
                                 default = nil)
  if valid_589225 != nil:
    section.add "sinkName", valid_589225
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
  var valid_589226 = query.getOrDefault("upload_protocol")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "upload_protocol", valid_589226
  var valid_589227 = query.getOrDefault("fields")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "fields", valid_589227
  var valid_589228 = query.getOrDefault("quotaUser")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "quotaUser", valid_589228
  var valid_589229 = query.getOrDefault("alt")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = newJString("json"))
  if valid_589229 != nil:
    section.add "alt", valid_589229
  var valid_589230 = query.getOrDefault("oauth_token")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "oauth_token", valid_589230
  var valid_589231 = query.getOrDefault("callback")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "callback", valid_589231
  var valid_589232 = query.getOrDefault("access_token")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "access_token", valid_589232
  var valid_589233 = query.getOrDefault("uploadType")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "uploadType", valid_589233
  var valid_589234 = query.getOrDefault("key")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "key", valid_589234
  var valid_589235 = query.getOrDefault("$.xgafv")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = newJString("1"))
  if valid_589235 != nil:
    section.add "$.xgafv", valid_589235
  var valid_589236 = query.getOrDefault("prettyPrint")
  valid_589236 = validateParameter(valid_589236, JBool, required = false,
                                 default = newJBool(true))
  if valid_589236 != nil:
    section.add "prettyPrint", valid_589236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589237: Call_LoggingProjectsSinksDelete_589222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a sink. If the sink has a unique writer_identity, then that service account is also deleted.
  ## 
  let valid = call_589237.validator(path, query, header, formData, body)
  let scheme = call_589237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589237.url(scheme.get, call_589237.host, call_589237.base,
                         call_589237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589237, url, valid)

proc call*(call_589238: Call_LoggingProjectsSinksDelete_589222; sinkName: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## loggingProjectsSinksDelete
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
  var path_589239 = newJObject()
  var query_589240 = newJObject()
  add(query_589240, "upload_protocol", newJString(uploadProtocol))
  add(query_589240, "fields", newJString(fields))
  add(query_589240, "quotaUser", newJString(quotaUser))
  add(path_589239, "sinkName", newJString(sinkName))
  add(query_589240, "alt", newJString(alt))
  add(query_589240, "oauth_token", newJString(oauthToken))
  add(query_589240, "callback", newJString(callback))
  add(query_589240, "access_token", newJString(accessToken))
  add(query_589240, "uploadType", newJString(uploadType))
  add(query_589240, "key", newJString(key))
  add(query_589240, "$.xgafv", newJString(Xgafv))
  add(query_589240, "prettyPrint", newJBool(prettyPrint))
  result = call_589238.call(path_589239, query_589240, nil, nil, nil)

var loggingProjectsSinksDelete* = Call_LoggingProjectsSinksDelete_589222(
    name: "loggingProjectsSinksDelete", meth: HttpMethod.HttpDelete,
    host: "logging.googleapis.com", route: "/v2beta1/{sinkName}",
    validator: validate_LoggingProjectsSinksDelete_589223, base: "/",
    url: url_LoggingProjectsSinksDelete_589224, schemes: {Scheme.Https})
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
