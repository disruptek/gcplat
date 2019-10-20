
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "logging"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LoggingEntriesList_578610 = ref object of OpenApiRestCall_578339
proc url_LoggingEntriesList_578612(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_LoggingEntriesList_578611(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists log entries. Use this method to retrieve log entries that originated from a project/folder/organization/billing account. For ways to export log entries, see Exporting Logs.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578724 = query.getOrDefault("key")
  valid_578724 = validateParameter(valid_578724, JString, required = false,
                                 default = nil)
  if valid_578724 != nil:
    section.add "key", valid_578724
  var valid_578738 = query.getOrDefault("prettyPrint")
  valid_578738 = validateParameter(valid_578738, JBool, required = false,
                                 default = newJBool(true))
  if valid_578738 != nil:
    section.add "prettyPrint", valid_578738
  var valid_578739 = query.getOrDefault("oauth_token")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "oauth_token", valid_578739
  var valid_578740 = query.getOrDefault("$.xgafv")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = newJString("1"))
  if valid_578740 != nil:
    section.add "$.xgafv", valid_578740
  var valid_578741 = query.getOrDefault("alt")
  valid_578741 = validateParameter(valid_578741, JString, required = false,
                                 default = newJString("json"))
  if valid_578741 != nil:
    section.add "alt", valid_578741
  var valid_578742 = query.getOrDefault("uploadType")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = nil)
  if valid_578742 != nil:
    section.add "uploadType", valid_578742
  var valid_578743 = query.getOrDefault("quotaUser")
  valid_578743 = validateParameter(valid_578743, JString, required = false,
                                 default = nil)
  if valid_578743 != nil:
    section.add "quotaUser", valid_578743
  var valid_578744 = query.getOrDefault("callback")
  valid_578744 = validateParameter(valid_578744, JString, required = false,
                                 default = nil)
  if valid_578744 != nil:
    section.add "callback", valid_578744
  var valid_578745 = query.getOrDefault("fields")
  valid_578745 = validateParameter(valid_578745, JString, required = false,
                                 default = nil)
  if valid_578745 != nil:
    section.add "fields", valid_578745
  var valid_578746 = query.getOrDefault("access_token")
  valid_578746 = validateParameter(valid_578746, JString, required = false,
                                 default = nil)
  if valid_578746 != nil:
    section.add "access_token", valid_578746
  var valid_578747 = query.getOrDefault("upload_protocol")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = nil)
  if valid_578747 != nil:
    section.add "upload_protocol", valid_578747
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

proc call*(call_578771: Call_LoggingEntriesList_578610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists log entries. Use this method to retrieve log entries that originated from a project/folder/organization/billing account. For ways to export log entries, see Exporting Logs.
  ## 
  let valid = call_578771.validator(path, query, header, formData, body)
  let scheme = call_578771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578771.url(scheme.get, call_578771.host, call_578771.base,
                         call_578771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578771, url, valid)

proc call*(call_578842: Call_LoggingEntriesList_578610; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## loggingEntriesList
  ## Lists log entries. Use this method to retrieve log entries that originated from a project/folder/organization/billing account. For ways to export log entries, see Exporting Logs.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578843 = newJObject()
  var body_578845 = newJObject()
  add(query_578843, "key", newJString(key))
  add(query_578843, "prettyPrint", newJBool(prettyPrint))
  add(query_578843, "oauth_token", newJString(oauthToken))
  add(query_578843, "$.xgafv", newJString(Xgafv))
  add(query_578843, "alt", newJString(alt))
  add(query_578843, "uploadType", newJString(uploadType))
  add(query_578843, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578845 = body
  add(query_578843, "callback", newJString(callback))
  add(query_578843, "fields", newJString(fields))
  add(query_578843, "access_token", newJString(accessToken))
  add(query_578843, "upload_protocol", newJString(uploadProtocol))
  result = call_578842.call(nil, query_578843, nil, nil, body_578845)

var loggingEntriesList* = Call_LoggingEntriesList_578610(
    name: "loggingEntriesList", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2/entries:list",
    validator: validate_LoggingEntriesList_578611, base: "/",
    url: url_LoggingEntriesList_578612, schemes: {Scheme.Https})
type
  Call_LoggingEntriesWrite_578884 = ref object of OpenApiRestCall_578339
proc url_LoggingEntriesWrite_578886(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_LoggingEntriesWrite_578885(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Writes log entries to Logging. This API method is the only way to send log entries to Logging. This method is used, directly or indirectly, by the Logging agent (fluentd) and all logging libraries configured to use Logging. A single request may contain log entries for a maximum of 1000 different resources (projects, organizations, billing accounts or folders)
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578887 = query.getOrDefault("key")
  valid_578887 = validateParameter(valid_578887, JString, required = false,
                                 default = nil)
  if valid_578887 != nil:
    section.add "key", valid_578887
  var valid_578888 = query.getOrDefault("prettyPrint")
  valid_578888 = validateParameter(valid_578888, JBool, required = false,
                                 default = newJBool(true))
  if valid_578888 != nil:
    section.add "prettyPrint", valid_578888
  var valid_578889 = query.getOrDefault("oauth_token")
  valid_578889 = validateParameter(valid_578889, JString, required = false,
                                 default = nil)
  if valid_578889 != nil:
    section.add "oauth_token", valid_578889
  var valid_578890 = query.getOrDefault("$.xgafv")
  valid_578890 = validateParameter(valid_578890, JString, required = false,
                                 default = newJString("1"))
  if valid_578890 != nil:
    section.add "$.xgafv", valid_578890
  var valid_578891 = query.getOrDefault("alt")
  valid_578891 = validateParameter(valid_578891, JString, required = false,
                                 default = newJString("json"))
  if valid_578891 != nil:
    section.add "alt", valid_578891
  var valid_578892 = query.getOrDefault("uploadType")
  valid_578892 = validateParameter(valid_578892, JString, required = false,
                                 default = nil)
  if valid_578892 != nil:
    section.add "uploadType", valid_578892
  var valid_578893 = query.getOrDefault("quotaUser")
  valid_578893 = validateParameter(valid_578893, JString, required = false,
                                 default = nil)
  if valid_578893 != nil:
    section.add "quotaUser", valid_578893
  var valid_578894 = query.getOrDefault("callback")
  valid_578894 = validateParameter(valid_578894, JString, required = false,
                                 default = nil)
  if valid_578894 != nil:
    section.add "callback", valid_578894
  var valid_578895 = query.getOrDefault("fields")
  valid_578895 = validateParameter(valid_578895, JString, required = false,
                                 default = nil)
  if valid_578895 != nil:
    section.add "fields", valid_578895
  var valid_578896 = query.getOrDefault("access_token")
  valid_578896 = validateParameter(valid_578896, JString, required = false,
                                 default = nil)
  if valid_578896 != nil:
    section.add "access_token", valid_578896
  var valid_578897 = query.getOrDefault("upload_protocol")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "upload_protocol", valid_578897
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

proc call*(call_578899: Call_LoggingEntriesWrite_578884; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Writes log entries to Logging. This API method is the only way to send log entries to Logging. This method is used, directly or indirectly, by the Logging agent (fluentd) and all logging libraries configured to use Logging. A single request may contain log entries for a maximum of 1000 different resources (projects, organizations, billing accounts or folders)
  ## 
  let valid = call_578899.validator(path, query, header, formData, body)
  let scheme = call_578899.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578899.url(scheme.get, call_578899.host, call_578899.base,
                         call_578899.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578899, url, valid)

proc call*(call_578900: Call_LoggingEntriesWrite_578884; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## loggingEntriesWrite
  ## Writes log entries to Logging. This API method is the only way to send log entries to Logging. This method is used, directly or indirectly, by the Logging agent (fluentd) and all logging libraries configured to use Logging. A single request may contain log entries for a maximum of 1000 different resources (projects, organizations, billing accounts or folders)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578901 = newJObject()
  var body_578902 = newJObject()
  add(query_578901, "key", newJString(key))
  add(query_578901, "prettyPrint", newJBool(prettyPrint))
  add(query_578901, "oauth_token", newJString(oauthToken))
  add(query_578901, "$.xgafv", newJString(Xgafv))
  add(query_578901, "alt", newJString(alt))
  add(query_578901, "uploadType", newJString(uploadType))
  add(query_578901, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578902 = body
  add(query_578901, "callback", newJString(callback))
  add(query_578901, "fields", newJString(fields))
  add(query_578901, "access_token", newJString(accessToken))
  add(query_578901, "upload_protocol", newJString(uploadProtocol))
  result = call_578900.call(nil, query_578901, nil, nil, body_578902)

var loggingEntriesWrite* = Call_LoggingEntriesWrite_578884(
    name: "loggingEntriesWrite", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2/entries:write",
    validator: validate_LoggingEntriesWrite_578885, base: "/",
    url: url_LoggingEntriesWrite_578886, schemes: {Scheme.Https})
type
  Call_LoggingMonitoredResourceDescriptorsList_578903 = ref object of OpenApiRestCall_578339
proc url_LoggingMonitoredResourceDescriptorsList_578905(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_LoggingMonitoredResourceDescriptorsList_578904(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the descriptors for monitored resource types used by Logging.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of results to return from this request. Non-positive values are ignored. The presence of nextPageToken in the response indicates that more results might be available.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional. If present, then retrieve the next batch of results from the preceding call to this method. pageToken must be the value of nextPageToken from the previous response. The values of other method parameters should be identical to those in the previous call.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578906 = query.getOrDefault("key")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "key", valid_578906
  var valid_578907 = query.getOrDefault("prettyPrint")
  valid_578907 = validateParameter(valid_578907, JBool, required = false,
                                 default = newJBool(true))
  if valid_578907 != nil:
    section.add "prettyPrint", valid_578907
  var valid_578908 = query.getOrDefault("oauth_token")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "oauth_token", valid_578908
  var valid_578909 = query.getOrDefault("$.xgafv")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = newJString("1"))
  if valid_578909 != nil:
    section.add "$.xgafv", valid_578909
  var valid_578910 = query.getOrDefault("pageSize")
  valid_578910 = validateParameter(valid_578910, JInt, required = false, default = nil)
  if valid_578910 != nil:
    section.add "pageSize", valid_578910
  var valid_578911 = query.getOrDefault("alt")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = newJString("json"))
  if valid_578911 != nil:
    section.add "alt", valid_578911
  var valid_578912 = query.getOrDefault("uploadType")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "uploadType", valid_578912
  var valid_578913 = query.getOrDefault("quotaUser")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "quotaUser", valid_578913
  var valid_578914 = query.getOrDefault("pageToken")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "pageToken", valid_578914
  var valid_578915 = query.getOrDefault("callback")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "callback", valid_578915
  var valid_578916 = query.getOrDefault("fields")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "fields", valid_578916
  var valid_578917 = query.getOrDefault("access_token")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "access_token", valid_578917
  var valid_578918 = query.getOrDefault("upload_protocol")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "upload_protocol", valid_578918
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578919: Call_LoggingMonitoredResourceDescriptorsList_578903;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the descriptors for monitored resource types used by Logging.
  ## 
  let valid = call_578919.validator(path, query, header, formData, body)
  let scheme = call_578919.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578919.url(scheme.get, call_578919.host, call_578919.base,
                         call_578919.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578919, url, valid)

proc call*(call_578920: Call_LoggingMonitoredResourceDescriptorsList_578903;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## loggingMonitoredResourceDescriptorsList
  ## Lists the descriptors for monitored resource types used by Logging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of results to return from this request. Non-positive values are ignored. The presence of nextPageToken in the response indicates that more results might be available.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional. If present, then retrieve the next batch of results from the preceding call to this method. pageToken must be the value of nextPageToken from the previous response. The values of other method parameters should be identical to those in the previous call.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578921 = newJObject()
  add(query_578921, "key", newJString(key))
  add(query_578921, "prettyPrint", newJBool(prettyPrint))
  add(query_578921, "oauth_token", newJString(oauthToken))
  add(query_578921, "$.xgafv", newJString(Xgafv))
  add(query_578921, "pageSize", newJInt(pageSize))
  add(query_578921, "alt", newJString(alt))
  add(query_578921, "uploadType", newJString(uploadType))
  add(query_578921, "quotaUser", newJString(quotaUser))
  add(query_578921, "pageToken", newJString(pageToken))
  add(query_578921, "callback", newJString(callback))
  add(query_578921, "fields", newJString(fields))
  add(query_578921, "access_token", newJString(accessToken))
  add(query_578921, "upload_protocol", newJString(uploadProtocol))
  result = call_578920.call(nil, query_578921, nil, nil, nil)

var loggingMonitoredResourceDescriptorsList* = Call_LoggingMonitoredResourceDescriptorsList_578903(
    name: "loggingMonitoredResourceDescriptorsList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/monitoredResourceDescriptors",
    validator: validate_LoggingMonitoredResourceDescriptorsList_578904, base: "/",
    url: url_LoggingMonitoredResourceDescriptorsList_578905,
    schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsLogsDelete_578922 = ref object of OpenApiRestCall_578339
proc url_LoggingOrganizationsLogsDelete_578924(protocol: Scheme; host: string;
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

proc validate_LoggingOrganizationsLogsDelete_578923(path: JsonNode;
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
  var valid_578939 = path.getOrDefault("logName")
  valid_578939 = validateParameter(valid_578939, JString, required = true,
                                 default = nil)
  if valid_578939 != nil:
    section.add "logName", valid_578939
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578940 = query.getOrDefault("key")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "key", valid_578940
  var valid_578941 = query.getOrDefault("prettyPrint")
  valid_578941 = validateParameter(valid_578941, JBool, required = false,
                                 default = newJBool(true))
  if valid_578941 != nil:
    section.add "prettyPrint", valid_578941
  var valid_578942 = query.getOrDefault("oauth_token")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "oauth_token", valid_578942
  var valid_578943 = query.getOrDefault("$.xgafv")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = newJString("1"))
  if valid_578943 != nil:
    section.add "$.xgafv", valid_578943
  var valid_578944 = query.getOrDefault("alt")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = newJString("json"))
  if valid_578944 != nil:
    section.add "alt", valid_578944
  var valid_578945 = query.getOrDefault("uploadType")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "uploadType", valid_578945
  var valid_578946 = query.getOrDefault("quotaUser")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "quotaUser", valid_578946
  var valid_578947 = query.getOrDefault("callback")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "callback", valid_578947
  var valid_578948 = query.getOrDefault("fields")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "fields", valid_578948
  var valid_578949 = query.getOrDefault("access_token")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "access_token", valid_578949
  var valid_578950 = query.getOrDefault("upload_protocol")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "upload_protocol", valid_578950
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578951: Call_LoggingOrganizationsLogsDelete_578922; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes all the log entries in a log. The log reappears if it receives new entries. Log entries written shortly before the delete operation might not be deleted.
  ## 
  let valid = call_578951.validator(path, query, header, formData, body)
  let scheme = call_578951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578951.url(scheme.get, call_578951.host, call_578951.base,
                         call_578951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578951, url, valid)

proc call*(call_578952: Call_LoggingOrganizationsLogsDelete_578922;
          logName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## loggingOrganizationsLogsDelete
  ## Deletes all the log entries in a log. The log reappears if it receives new entries. Log entries written shortly before the delete operation might not be deleted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   logName: string (required)
  ##          : Required. The resource name of the log to delete:
  ## "projects/[PROJECT_ID]/logs/[LOG_ID]"
  ## "organizations/[ORGANIZATION_ID]/logs/[LOG_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/logs/[LOG_ID]"
  ## "folders/[FOLDER_ID]/logs/[LOG_ID]"
  ## [LOG_ID] must be URL-encoded. For example, "projects/my-project-id/logs/syslog", 
  ## "organizations/1234567890/logs/cloudresourcemanager.googleapis.com%2Factivity". For more information about log names, see LogEntry.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578953 = newJObject()
  var query_578954 = newJObject()
  add(query_578954, "key", newJString(key))
  add(query_578954, "prettyPrint", newJBool(prettyPrint))
  add(query_578954, "oauth_token", newJString(oauthToken))
  add(query_578954, "$.xgafv", newJString(Xgafv))
  add(query_578954, "alt", newJString(alt))
  add(query_578954, "uploadType", newJString(uploadType))
  add(query_578954, "quotaUser", newJString(quotaUser))
  add(path_578953, "logName", newJString(logName))
  add(query_578954, "callback", newJString(callback))
  add(query_578954, "fields", newJString(fields))
  add(query_578954, "access_token", newJString(accessToken))
  add(query_578954, "upload_protocol", newJString(uploadProtocol))
  result = call_578952.call(path_578953, query_578954, nil, nil, nil)

var loggingOrganizationsLogsDelete* = Call_LoggingOrganizationsLogsDelete_578922(
    name: "loggingOrganizationsLogsDelete", meth: HttpMethod.HttpDelete,
    host: "logging.googleapis.com", route: "/v2/{logName}",
    validator: validate_LoggingOrganizationsLogsDelete_578923, base: "/",
    url: url_LoggingOrganizationsLogsDelete_578924, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsUpdate_578974 = ref object of OpenApiRestCall_578339
proc url_LoggingProjectsMetricsUpdate_578976(protocol: Scheme; host: string;
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

proc validate_LoggingProjectsMetricsUpdate_578975(path: JsonNode; query: JsonNode;
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
  var valid_578977 = path.getOrDefault("metricName")
  valid_578977 = validateParameter(valid_578977, JString, required = true,
                                 default = nil)
  if valid_578977 != nil:
    section.add "metricName", valid_578977
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578978 = query.getOrDefault("key")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "key", valid_578978
  var valid_578979 = query.getOrDefault("prettyPrint")
  valid_578979 = validateParameter(valid_578979, JBool, required = false,
                                 default = newJBool(true))
  if valid_578979 != nil:
    section.add "prettyPrint", valid_578979
  var valid_578980 = query.getOrDefault("oauth_token")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "oauth_token", valid_578980
  var valid_578981 = query.getOrDefault("$.xgafv")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = newJString("1"))
  if valid_578981 != nil:
    section.add "$.xgafv", valid_578981
  var valid_578982 = query.getOrDefault("alt")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = newJString("json"))
  if valid_578982 != nil:
    section.add "alt", valid_578982
  var valid_578983 = query.getOrDefault("uploadType")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "uploadType", valid_578983
  var valid_578984 = query.getOrDefault("quotaUser")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "quotaUser", valid_578984
  var valid_578985 = query.getOrDefault("callback")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "callback", valid_578985
  var valid_578986 = query.getOrDefault("fields")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "fields", valid_578986
  var valid_578987 = query.getOrDefault("access_token")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "access_token", valid_578987
  var valid_578988 = query.getOrDefault("upload_protocol")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "upload_protocol", valid_578988
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

proc call*(call_578990: Call_LoggingProjectsMetricsUpdate_578974; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a logs-based metric.
  ## 
  let valid = call_578990.validator(path, query, header, formData, body)
  let scheme = call_578990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578990.url(scheme.get, call_578990.host, call_578990.base,
                         call_578990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578990, url, valid)

proc call*(call_578991: Call_LoggingProjectsMetricsUpdate_578974;
          metricName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## loggingProjectsMetricsUpdate
  ## Creates or updates a logs-based metric.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   metricName: string (required)
  ##             : The resource name of the metric to update:
  ## "projects/[PROJECT_ID]/metrics/[METRIC_ID]"
  ## The updated metric must be provided in the request and it's name field must be the same as [METRIC_ID] If the metric does not exist in [PROJECT_ID], then a new metric is created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578992 = newJObject()
  var query_578993 = newJObject()
  var body_578994 = newJObject()
  add(query_578993, "key", newJString(key))
  add(query_578993, "prettyPrint", newJBool(prettyPrint))
  add(query_578993, "oauth_token", newJString(oauthToken))
  add(query_578993, "$.xgafv", newJString(Xgafv))
  add(query_578993, "alt", newJString(alt))
  add(query_578993, "uploadType", newJString(uploadType))
  add(query_578993, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578994 = body
  add(query_578993, "callback", newJString(callback))
  add(path_578992, "metricName", newJString(metricName))
  add(query_578993, "fields", newJString(fields))
  add(query_578993, "access_token", newJString(accessToken))
  add(query_578993, "upload_protocol", newJString(uploadProtocol))
  result = call_578991.call(path_578992, query_578993, nil, nil, body_578994)

var loggingProjectsMetricsUpdate* = Call_LoggingProjectsMetricsUpdate_578974(
    name: "loggingProjectsMetricsUpdate", meth: HttpMethod.HttpPut,
    host: "logging.googleapis.com", route: "/v2/{metricName}",
    validator: validate_LoggingProjectsMetricsUpdate_578975, base: "/",
    url: url_LoggingProjectsMetricsUpdate_578976, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsGet_578955 = ref object of OpenApiRestCall_578339
proc url_LoggingProjectsMetricsGet_578957(protocol: Scheme; host: string;
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

proc validate_LoggingProjectsMetricsGet_578956(path: JsonNode; query: JsonNode;
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
  var valid_578958 = path.getOrDefault("metricName")
  valid_578958 = validateParameter(valid_578958, JString, required = true,
                                 default = nil)
  if valid_578958 != nil:
    section.add "metricName", valid_578958
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578959 = query.getOrDefault("key")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "key", valid_578959
  var valid_578960 = query.getOrDefault("prettyPrint")
  valid_578960 = validateParameter(valid_578960, JBool, required = false,
                                 default = newJBool(true))
  if valid_578960 != nil:
    section.add "prettyPrint", valid_578960
  var valid_578961 = query.getOrDefault("oauth_token")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "oauth_token", valid_578961
  var valid_578962 = query.getOrDefault("$.xgafv")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = newJString("1"))
  if valid_578962 != nil:
    section.add "$.xgafv", valid_578962
  var valid_578963 = query.getOrDefault("alt")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = newJString("json"))
  if valid_578963 != nil:
    section.add "alt", valid_578963
  var valid_578964 = query.getOrDefault("uploadType")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "uploadType", valid_578964
  var valid_578965 = query.getOrDefault("quotaUser")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "quotaUser", valid_578965
  var valid_578966 = query.getOrDefault("callback")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "callback", valid_578966
  var valid_578967 = query.getOrDefault("fields")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "fields", valid_578967
  var valid_578968 = query.getOrDefault("access_token")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "access_token", valid_578968
  var valid_578969 = query.getOrDefault("upload_protocol")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "upload_protocol", valid_578969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578970: Call_LoggingProjectsMetricsGet_578955; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a logs-based metric.
  ## 
  let valid = call_578970.validator(path, query, header, formData, body)
  let scheme = call_578970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578970.url(scheme.get, call_578970.host, call_578970.base,
                         call_578970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578970, url, valid)

proc call*(call_578971: Call_LoggingProjectsMetricsGet_578955; metricName: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## loggingProjectsMetricsGet
  ## Gets a logs-based metric.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   metricName: string (required)
  ##             : The resource name of the desired metric:
  ## "projects/[PROJECT_ID]/metrics/[METRIC_ID]"
  ## 
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578972 = newJObject()
  var query_578973 = newJObject()
  add(query_578973, "key", newJString(key))
  add(query_578973, "prettyPrint", newJBool(prettyPrint))
  add(query_578973, "oauth_token", newJString(oauthToken))
  add(query_578973, "$.xgafv", newJString(Xgafv))
  add(query_578973, "alt", newJString(alt))
  add(query_578973, "uploadType", newJString(uploadType))
  add(query_578973, "quotaUser", newJString(quotaUser))
  add(query_578973, "callback", newJString(callback))
  add(path_578972, "metricName", newJString(metricName))
  add(query_578973, "fields", newJString(fields))
  add(query_578973, "access_token", newJString(accessToken))
  add(query_578973, "upload_protocol", newJString(uploadProtocol))
  result = call_578971.call(path_578972, query_578973, nil, nil, nil)

var loggingProjectsMetricsGet* = Call_LoggingProjectsMetricsGet_578955(
    name: "loggingProjectsMetricsGet", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{metricName}",
    validator: validate_LoggingProjectsMetricsGet_578956, base: "/",
    url: url_LoggingProjectsMetricsGet_578957, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsDelete_578995 = ref object of OpenApiRestCall_578339
proc url_LoggingProjectsMetricsDelete_578997(protocol: Scheme; host: string;
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

proc validate_LoggingProjectsMetricsDelete_578996(path: JsonNode; query: JsonNode;
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
  var valid_578998 = path.getOrDefault("metricName")
  valid_578998 = validateParameter(valid_578998, JString, required = true,
                                 default = nil)
  if valid_578998 != nil:
    section.add "metricName", valid_578998
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578999 = query.getOrDefault("key")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "key", valid_578999
  var valid_579000 = query.getOrDefault("prettyPrint")
  valid_579000 = validateParameter(valid_579000, JBool, required = false,
                                 default = newJBool(true))
  if valid_579000 != nil:
    section.add "prettyPrint", valid_579000
  var valid_579001 = query.getOrDefault("oauth_token")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "oauth_token", valid_579001
  var valid_579002 = query.getOrDefault("$.xgafv")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = newJString("1"))
  if valid_579002 != nil:
    section.add "$.xgafv", valid_579002
  var valid_579003 = query.getOrDefault("alt")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = newJString("json"))
  if valid_579003 != nil:
    section.add "alt", valid_579003
  var valid_579004 = query.getOrDefault("uploadType")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "uploadType", valid_579004
  var valid_579005 = query.getOrDefault("quotaUser")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "quotaUser", valid_579005
  var valid_579006 = query.getOrDefault("callback")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "callback", valid_579006
  var valid_579007 = query.getOrDefault("fields")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "fields", valid_579007
  var valid_579008 = query.getOrDefault("access_token")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "access_token", valid_579008
  var valid_579009 = query.getOrDefault("upload_protocol")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "upload_protocol", valid_579009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579010: Call_LoggingProjectsMetricsDelete_578995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a logs-based metric.
  ## 
  let valid = call_579010.validator(path, query, header, formData, body)
  let scheme = call_579010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579010.url(scheme.get, call_579010.host, call_579010.base,
                         call_579010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579010, url, valid)

proc call*(call_579011: Call_LoggingProjectsMetricsDelete_578995;
          metricName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## loggingProjectsMetricsDelete
  ## Deletes a logs-based metric.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   metricName: string (required)
  ##             : The resource name of the metric to delete:
  ## "projects/[PROJECT_ID]/metrics/[METRIC_ID]"
  ## 
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579012 = newJObject()
  var query_579013 = newJObject()
  add(query_579013, "key", newJString(key))
  add(query_579013, "prettyPrint", newJBool(prettyPrint))
  add(query_579013, "oauth_token", newJString(oauthToken))
  add(query_579013, "$.xgafv", newJString(Xgafv))
  add(query_579013, "alt", newJString(alt))
  add(query_579013, "uploadType", newJString(uploadType))
  add(query_579013, "quotaUser", newJString(quotaUser))
  add(query_579013, "callback", newJString(callback))
  add(path_579012, "metricName", newJString(metricName))
  add(query_579013, "fields", newJString(fields))
  add(query_579013, "access_token", newJString(accessToken))
  add(query_579013, "upload_protocol", newJString(uploadProtocol))
  result = call_579011.call(path_579012, query_579013, nil, nil, nil)

var loggingProjectsMetricsDelete* = Call_LoggingProjectsMetricsDelete_578995(
    name: "loggingProjectsMetricsDelete", meth: HttpMethod.HttpDelete,
    host: "logging.googleapis.com", route: "/v2/{metricName}",
    validator: validate_LoggingProjectsMetricsDelete_578996, base: "/",
    url: url_LoggingProjectsMetricsDelete_578997, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsExclusionsGet_579014 = ref object of OpenApiRestCall_578339
proc url_LoggingOrganizationsExclusionsGet_579016(protocol: Scheme; host: string;
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

proc validate_LoggingOrganizationsExclusionsGet_579015(path: JsonNode;
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
  var valid_579017 = path.getOrDefault("name")
  valid_579017 = validateParameter(valid_579017, JString, required = true,
                                 default = nil)
  if valid_579017 != nil:
    section.add "name", valid_579017
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579018 = query.getOrDefault("key")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "key", valid_579018
  var valid_579019 = query.getOrDefault("prettyPrint")
  valid_579019 = validateParameter(valid_579019, JBool, required = false,
                                 default = newJBool(true))
  if valid_579019 != nil:
    section.add "prettyPrint", valid_579019
  var valid_579020 = query.getOrDefault("oauth_token")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "oauth_token", valid_579020
  var valid_579021 = query.getOrDefault("$.xgafv")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = newJString("1"))
  if valid_579021 != nil:
    section.add "$.xgafv", valid_579021
  var valid_579022 = query.getOrDefault("alt")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = newJString("json"))
  if valid_579022 != nil:
    section.add "alt", valid_579022
  var valid_579023 = query.getOrDefault("uploadType")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "uploadType", valid_579023
  var valid_579024 = query.getOrDefault("quotaUser")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "quotaUser", valid_579024
  var valid_579025 = query.getOrDefault("callback")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "callback", valid_579025
  var valid_579026 = query.getOrDefault("fields")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "fields", valid_579026
  var valid_579027 = query.getOrDefault("access_token")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "access_token", valid_579027
  var valid_579028 = query.getOrDefault("upload_protocol")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "upload_protocol", valid_579028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579029: Call_LoggingOrganizationsExclusionsGet_579014;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the description of an exclusion.
  ## 
  let valid = call_579029.validator(path, query, header, formData, body)
  let scheme = call_579029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579029.url(scheme.get, call_579029.host, call_579029.base,
                         call_579029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579029, url, valid)

proc call*(call_579030: Call_LoggingOrganizationsExclusionsGet_579014;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## loggingOrganizationsExclusionsGet
  ## Gets the description of an exclusion.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of an existing exclusion:
  ## "projects/[PROJECT_ID]/exclusions/[EXCLUSION_ID]"
  ## "organizations/[ORGANIZATION_ID]/exclusions/[EXCLUSION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/exclusions/[EXCLUSION_ID]"
  ## "folders/[FOLDER_ID]/exclusions/[EXCLUSION_ID]"
  ## Example: "projects/my-project-id/exclusions/my-exclusion-id".
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579031 = newJObject()
  var query_579032 = newJObject()
  add(query_579032, "key", newJString(key))
  add(query_579032, "prettyPrint", newJBool(prettyPrint))
  add(query_579032, "oauth_token", newJString(oauthToken))
  add(query_579032, "$.xgafv", newJString(Xgafv))
  add(query_579032, "alt", newJString(alt))
  add(query_579032, "uploadType", newJString(uploadType))
  add(query_579032, "quotaUser", newJString(quotaUser))
  add(path_579031, "name", newJString(name))
  add(query_579032, "callback", newJString(callback))
  add(query_579032, "fields", newJString(fields))
  add(query_579032, "access_token", newJString(accessToken))
  add(query_579032, "upload_protocol", newJString(uploadProtocol))
  result = call_579030.call(path_579031, query_579032, nil, nil, nil)

var loggingOrganizationsExclusionsGet* = Call_LoggingOrganizationsExclusionsGet_579014(
    name: "loggingOrganizationsExclusionsGet", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{name}",
    validator: validate_LoggingOrganizationsExclusionsGet_579015, base: "/",
    url: url_LoggingOrganizationsExclusionsGet_579016, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsExclusionsPatch_579052 = ref object of OpenApiRestCall_578339
proc url_LoggingOrganizationsExclusionsPatch_579054(protocol: Scheme; host: string;
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

proc validate_LoggingOrganizationsExclusionsPatch_579053(path: JsonNode;
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
  var valid_579055 = path.getOrDefault("name")
  valid_579055 = validateParameter(valid_579055, JString, required = true,
                                 default = nil)
  if valid_579055 != nil:
    section.add "name", valid_579055
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : Required. A non-empty list of fields to change in the existing exclusion. New values for the fields are taken from the corresponding fields in the LogExclusion included in this request. Fields not mentioned in update_mask are not changed and are ignored in the request.For example, to change the filter and description of an exclusion, specify an update_mask of "filter,description".
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579056 = query.getOrDefault("key")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "key", valid_579056
  var valid_579057 = query.getOrDefault("prettyPrint")
  valid_579057 = validateParameter(valid_579057, JBool, required = false,
                                 default = newJBool(true))
  if valid_579057 != nil:
    section.add "prettyPrint", valid_579057
  var valid_579058 = query.getOrDefault("oauth_token")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "oauth_token", valid_579058
  var valid_579059 = query.getOrDefault("$.xgafv")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = newJString("1"))
  if valid_579059 != nil:
    section.add "$.xgafv", valid_579059
  var valid_579060 = query.getOrDefault("alt")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = newJString("json"))
  if valid_579060 != nil:
    section.add "alt", valid_579060
  var valid_579061 = query.getOrDefault("uploadType")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "uploadType", valid_579061
  var valid_579062 = query.getOrDefault("quotaUser")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "quotaUser", valid_579062
  var valid_579063 = query.getOrDefault("updateMask")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "updateMask", valid_579063
  var valid_579064 = query.getOrDefault("callback")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "callback", valid_579064
  var valid_579065 = query.getOrDefault("fields")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "fields", valid_579065
  var valid_579066 = query.getOrDefault("access_token")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "access_token", valid_579066
  var valid_579067 = query.getOrDefault("upload_protocol")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "upload_protocol", valid_579067
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

proc call*(call_579069: Call_LoggingOrganizationsExclusionsPatch_579052;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Changes one or more properties of an existing exclusion.
  ## 
  let valid = call_579069.validator(path, query, header, formData, body)
  let scheme = call_579069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579069.url(scheme.get, call_579069.host, call_579069.base,
                         call_579069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579069, url, valid)

proc call*(call_579070: Call_LoggingOrganizationsExclusionsPatch_579052;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## loggingOrganizationsExclusionsPatch
  ## Changes one or more properties of an existing exclusion.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the exclusion to update:
  ## "projects/[PROJECT_ID]/exclusions/[EXCLUSION_ID]"
  ## "organizations/[ORGANIZATION_ID]/exclusions/[EXCLUSION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/exclusions/[EXCLUSION_ID]"
  ## "folders/[FOLDER_ID]/exclusions/[EXCLUSION_ID]"
  ## Example: "projects/my-project-id/exclusions/my-exclusion-id".
  ##   updateMask: string
  ##             : Required. A non-empty list of fields to change in the existing exclusion. New values for the fields are taken from the corresponding fields in the LogExclusion included in this request. Fields not mentioned in update_mask are not changed and are ignored in the request.For example, to change the filter and description of an exclusion, specify an update_mask of "filter,description".
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579071 = newJObject()
  var query_579072 = newJObject()
  var body_579073 = newJObject()
  add(query_579072, "key", newJString(key))
  add(query_579072, "prettyPrint", newJBool(prettyPrint))
  add(query_579072, "oauth_token", newJString(oauthToken))
  add(query_579072, "$.xgafv", newJString(Xgafv))
  add(query_579072, "alt", newJString(alt))
  add(query_579072, "uploadType", newJString(uploadType))
  add(query_579072, "quotaUser", newJString(quotaUser))
  add(path_579071, "name", newJString(name))
  add(query_579072, "updateMask", newJString(updateMask))
  if body != nil:
    body_579073 = body
  add(query_579072, "callback", newJString(callback))
  add(query_579072, "fields", newJString(fields))
  add(query_579072, "access_token", newJString(accessToken))
  add(query_579072, "upload_protocol", newJString(uploadProtocol))
  result = call_579070.call(path_579071, query_579072, nil, nil, body_579073)

var loggingOrganizationsExclusionsPatch* = Call_LoggingOrganizationsExclusionsPatch_579052(
    name: "loggingOrganizationsExclusionsPatch", meth: HttpMethod.HttpPatch,
    host: "logging.googleapis.com", route: "/v2/{name}",
    validator: validate_LoggingOrganizationsExclusionsPatch_579053, base: "/",
    url: url_LoggingOrganizationsExclusionsPatch_579054, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsExclusionsDelete_579033 = ref object of OpenApiRestCall_578339
proc url_LoggingOrganizationsExclusionsDelete_579035(protocol: Scheme;
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

proc validate_LoggingOrganizationsExclusionsDelete_579034(path: JsonNode;
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
  var valid_579036 = path.getOrDefault("name")
  valid_579036 = validateParameter(valid_579036, JString, required = true,
                                 default = nil)
  if valid_579036 != nil:
    section.add "name", valid_579036
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579037 = query.getOrDefault("key")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "key", valid_579037
  var valid_579038 = query.getOrDefault("prettyPrint")
  valid_579038 = validateParameter(valid_579038, JBool, required = false,
                                 default = newJBool(true))
  if valid_579038 != nil:
    section.add "prettyPrint", valid_579038
  var valid_579039 = query.getOrDefault("oauth_token")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "oauth_token", valid_579039
  var valid_579040 = query.getOrDefault("$.xgafv")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = newJString("1"))
  if valid_579040 != nil:
    section.add "$.xgafv", valid_579040
  var valid_579041 = query.getOrDefault("alt")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = newJString("json"))
  if valid_579041 != nil:
    section.add "alt", valid_579041
  var valid_579042 = query.getOrDefault("uploadType")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "uploadType", valid_579042
  var valid_579043 = query.getOrDefault("quotaUser")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "quotaUser", valid_579043
  var valid_579044 = query.getOrDefault("callback")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "callback", valid_579044
  var valid_579045 = query.getOrDefault("fields")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "fields", valid_579045
  var valid_579046 = query.getOrDefault("access_token")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "access_token", valid_579046
  var valid_579047 = query.getOrDefault("upload_protocol")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "upload_protocol", valid_579047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579048: Call_LoggingOrganizationsExclusionsDelete_579033;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an exclusion.
  ## 
  let valid = call_579048.validator(path, query, header, formData, body)
  let scheme = call_579048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579048.url(scheme.get, call_579048.host, call_579048.base,
                         call_579048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579048, url, valid)

proc call*(call_579049: Call_LoggingOrganizationsExclusionsDelete_579033;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## loggingOrganizationsExclusionsDelete
  ## Deletes an exclusion.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of an existing exclusion to delete:
  ## "projects/[PROJECT_ID]/exclusions/[EXCLUSION_ID]"
  ## "organizations/[ORGANIZATION_ID]/exclusions/[EXCLUSION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/exclusions/[EXCLUSION_ID]"
  ## "folders/[FOLDER_ID]/exclusions/[EXCLUSION_ID]"
  ## Example: "projects/my-project-id/exclusions/my-exclusion-id".
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579050 = newJObject()
  var query_579051 = newJObject()
  add(query_579051, "key", newJString(key))
  add(query_579051, "prettyPrint", newJBool(prettyPrint))
  add(query_579051, "oauth_token", newJString(oauthToken))
  add(query_579051, "$.xgafv", newJString(Xgafv))
  add(query_579051, "alt", newJString(alt))
  add(query_579051, "uploadType", newJString(uploadType))
  add(query_579051, "quotaUser", newJString(quotaUser))
  add(path_579050, "name", newJString(name))
  add(query_579051, "callback", newJString(callback))
  add(query_579051, "fields", newJString(fields))
  add(query_579051, "access_token", newJString(accessToken))
  add(query_579051, "upload_protocol", newJString(uploadProtocol))
  result = call_579049.call(path_579050, query_579051, nil, nil, nil)

var loggingOrganizationsExclusionsDelete* = Call_LoggingOrganizationsExclusionsDelete_579033(
    name: "loggingOrganizationsExclusionsDelete", meth: HttpMethod.HttpDelete,
    host: "logging.googleapis.com", route: "/v2/{name}",
    validator: validate_LoggingOrganizationsExclusionsDelete_579034, base: "/",
    url: url_LoggingOrganizationsExclusionsDelete_579035, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsExclusionsCreate_579095 = ref object of OpenApiRestCall_578339
proc url_LoggingOrganizationsExclusionsCreate_579097(protocol: Scheme;
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

proc validate_LoggingOrganizationsExclusionsCreate_579096(path: JsonNode;
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
  var valid_579098 = path.getOrDefault("parent")
  valid_579098 = validateParameter(valid_579098, JString, required = true,
                                 default = nil)
  if valid_579098 != nil:
    section.add "parent", valid_579098
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579099 = query.getOrDefault("key")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "key", valid_579099
  var valid_579100 = query.getOrDefault("prettyPrint")
  valid_579100 = validateParameter(valid_579100, JBool, required = false,
                                 default = newJBool(true))
  if valid_579100 != nil:
    section.add "prettyPrint", valid_579100
  var valid_579101 = query.getOrDefault("oauth_token")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "oauth_token", valid_579101
  var valid_579102 = query.getOrDefault("$.xgafv")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = newJString("1"))
  if valid_579102 != nil:
    section.add "$.xgafv", valid_579102
  var valid_579103 = query.getOrDefault("alt")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = newJString("json"))
  if valid_579103 != nil:
    section.add "alt", valid_579103
  var valid_579104 = query.getOrDefault("uploadType")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "uploadType", valid_579104
  var valid_579105 = query.getOrDefault("quotaUser")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "quotaUser", valid_579105
  var valid_579106 = query.getOrDefault("callback")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "callback", valid_579106
  var valid_579107 = query.getOrDefault("fields")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "fields", valid_579107
  var valid_579108 = query.getOrDefault("access_token")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "access_token", valid_579108
  var valid_579109 = query.getOrDefault("upload_protocol")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "upload_protocol", valid_579109
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

proc call*(call_579111: Call_LoggingOrganizationsExclusionsCreate_579095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new exclusion in a specified parent resource. Only log entries belonging to that resource can be excluded. You can have up to 10 exclusions in a resource.
  ## 
  let valid = call_579111.validator(path, query, header, formData, body)
  let scheme = call_579111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579111.url(scheme.get, call_579111.host, call_579111.base,
                         call_579111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579111, url, valid)

proc call*(call_579112: Call_LoggingOrganizationsExclusionsCreate_579095;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## loggingOrganizationsExclusionsCreate
  ## Creates a new exclusion in a specified parent resource. Only log entries belonging to that resource can be excluded. You can have up to 10 exclusions in a resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The parent resource in which to create the exclusion:
  ## "projects/[PROJECT_ID]"
  ## "organizations/[ORGANIZATION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]"
  ## "folders/[FOLDER_ID]"
  ## Examples: "projects/my-logging-project", "organizations/123456789".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579113 = newJObject()
  var query_579114 = newJObject()
  var body_579115 = newJObject()
  add(query_579114, "key", newJString(key))
  add(query_579114, "prettyPrint", newJBool(prettyPrint))
  add(query_579114, "oauth_token", newJString(oauthToken))
  add(query_579114, "$.xgafv", newJString(Xgafv))
  add(query_579114, "alt", newJString(alt))
  add(query_579114, "uploadType", newJString(uploadType))
  add(query_579114, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579115 = body
  add(query_579114, "callback", newJString(callback))
  add(path_579113, "parent", newJString(parent))
  add(query_579114, "fields", newJString(fields))
  add(query_579114, "access_token", newJString(accessToken))
  add(query_579114, "upload_protocol", newJString(uploadProtocol))
  result = call_579112.call(path_579113, query_579114, nil, nil, body_579115)

var loggingOrganizationsExclusionsCreate* = Call_LoggingOrganizationsExclusionsCreate_579095(
    name: "loggingOrganizationsExclusionsCreate", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2/{parent}/exclusions",
    validator: validate_LoggingOrganizationsExclusionsCreate_579096, base: "/",
    url: url_LoggingOrganizationsExclusionsCreate_579097, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsExclusionsList_579074 = ref object of OpenApiRestCall_578339
proc url_LoggingOrganizationsExclusionsList_579076(protocol: Scheme; host: string;
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

proc validate_LoggingOrganizationsExclusionsList_579075(path: JsonNode;
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
  var valid_579077 = path.getOrDefault("parent")
  valid_579077 = validateParameter(valid_579077, JString, required = true,
                                 default = nil)
  if valid_579077 != nil:
    section.add "parent", valid_579077
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of results to return from this request. Non-positive values are ignored. The presence of nextPageToken in the response indicates that more results might be available.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional. If present, then retrieve the next batch of results from the preceding call to this method. pageToken must be the value of nextPageToken from the previous response. The values of other method parameters should be identical to those in the previous call.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579078 = query.getOrDefault("key")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "key", valid_579078
  var valid_579079 = query.getOrDefault("prettyPrint")
  valid_579079 = validateParameter(valid_579079, JBool, required = false,
                                 default = newJBool(true))
  if valid_579079 != nil:
    section.add "prettyPrint", valid_579079
  var valid_579080 = query.getOrDefault("oauth_token")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "oauth_token", valid_579080
  var valid_579081 = query.getOrDefault("$.xgafv")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = newJString("1"))
  if valid_579081 != nil:
    section.add "$.xgafv", valid_579081
  var valid_579082 = query.getOrDefault("pageSize")
  valid_579082 = validateParameter(valid_579082, JInt, required = false, default = nil)
  if valid_579082 != nil:
    section.add "pageSize", valid_579082
  var valid_579083 = query.getOrDefault("alt")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = newJString("json"))
  if valid_579083 != nil:
    section.add "alt", valid_579083
  var valid_579084 = query.getOrDefault("uploadType")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "uploadType", valid_579084
  var valid_579085 = query.getOrDefault("quotaUser")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "quotaUser", valid_579085
  var valid_579086 = query.getOrDefault("pageToken")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "pageToken", valid_579086
  var valid_579087 = query.getOrDefault("callback")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "callback", valid_579087
  var valid_579088 = query.getOrDefault("fields")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "fields", valid_579088
  var valid_579089 = query.getOrDefault("access_token")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "access_token", valid_579089
  var valid_579090 = query.getOrDefault("upload_protocol")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "upload_protocol", valid_579090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579091: Call_LoggingOrganizationsExclusionsList_579074;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the exclusions in a parent resource.
  ## 
  let valid = call_579091.validator(path, query, header, formData, body)
  let scheme = call_579091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579091.url(scheme.get, call_579091.host, call_579091.base,
                         call_579091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579091, url, valid)

proc call*(call_579092: Call_LoggingOrganizationsExclusionsList_579074;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## loggingOrganizationsExclusionsList
  ## Lists all the exclusions in a parent resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of results to return from this request. Non-positive values are ignored. The presence of nextPageToken in the response indicates that more results might be available.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional. If present, then retrieve the next batch of results from the preceding call to this method. pageToken must be the value of nextPageToken from the previous response. The values of other method parameters should be identical to those in the previous call.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The parent resource whose exclusions are to be listed.
  ## "projects/[PROJECT_ID]"
  ## "organizations/[ORGANIZATION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]"
  ## "folders/[FOLDER_ID]"
  ## 
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579093 = newJObject()
  var query_579094 = newJObject()
  add(query_579094, "key", newJString(key))
  add(query_579094, "prettyPrint", newJBool(prettyPrint))
  add(query_579094, "oauth_token", newJString(oauthToken))
  add(query_579094, "$.xgafv", newJString(Xgafv))
  add(query_579094, "pageSize", newJInt(pageSize))
  add(query_579094, "alt", newJString(alt))
  add(query_579094, "uploadType", newJString(uploadType))
  add(query_579094, "quotaUser", newJString(quotaUser))
  add(query_579094, "pageToken", newJString(pageToken))
  add(query_579094, "callback", newJString(callback))
  add(path_579093, "parent", newJString(parent))
  add(query_579094, "fields", newJString(fields))
  add(query_579094, "access_token", newJString(accessToken))
  add(query_579094, "upload_protocol", newJString(uploadProtocol))
  result = call_579092.call(path_579093, query_579094, nil, nil, nil)

var loggingOrganizationsExclusionsList* = Call_LoggingOrganizationsExclusionsList_579074(
    name: "loggingOrganizationsExclusionsList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{parent}/exclusions",
    validator: validate_LoggingOrganizationsExclusionsList_579075, base: "/",
    url: url_LoggingOrganizationsExclusionsList_579076, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsLogsList_579116 = ref object of OpenApiRestCall_578339
proc url_LoggingOrganizationsLogsList_579118(protocol: Scheme; host: string;
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

proc validate_LoggingOrganizationsLogsList_579117(path: JsonNode; query: JsonNode;
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
  var valid_579119 = path.getOrDefault("parent")
  valid_579119 = validateParameter(valid_579119, JString, required = true,
                                 default = nil)
  if valid_579119 != nil:
    section.add "parent", valid_579119
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of results to return from this request. Non-positive values are ignored. The presence of nextPageToken in the response indicates that more results might be available.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional. If present, then retrieve the next batch of results from the preceding call to this method. pageToken must be the value of nextPageToken from the previous response. The values of other method parameters should be identical to those in the previous call.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579120 = query.getOrDefault("key")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "key", valid_579120
  var valid_579121 = query.getOrDefault("prettyPrint")
  valid_579121 = validateParameter(valid_579121, JBool, required = false,
                                 default = newJBool(true))
  if valid_579121 != nil:
    section.add "prettyPrint", valid_579121
  var valid_579122 = query.getOrDefault("oauth_token")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "oauth_token", valid_579122
  var valid_579123 = query.getOrDefault("$.xgafv")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = newJString("1"))
  if valid_579123 != nil:
    section.add "$.xgafv", valid_579123
  var valid_579124 = query.getOrDefault("pageSize")
  valid_579124 = validateParameter(valid_579124, JInt, required = false, default = nil)
  if valid_579124 != nil:
    section.add "pageSize", valid_579124
  var valid_579125 = query.getOrDefault("alt")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = newJString("json"))
  if valid_579125 != nil:
    section.add "alt", valid_579125
  var valid_579126 = query.getOrDefault("uploadType")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "uploadType", valid_579126
  var valid_579127 = query.getOrDefault("quotaUser")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "quotaUser", valid_579127
  var valid_579128 = query.getOrDefault("pageToken")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "pageToken", valid_579128
  var valid_579129 = query.getOrDefault("callback")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "callback", valid_579129
  var valid_579130 = query.getOrDefault("fields")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "fields", valid_579130
  var valid_579131 = query.getOrDefault("access_token")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "access_token", valid_579131
  var valid_579132 = query.getOrDefault("upload_protocol")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "upload_protocol", valid_579132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579133: Call_LoggingOrganizationsLogsList_579116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the logs in projects, organizations, folders, or billing accounts. Only logs that have entries are listed.
  ## 
  let valid = call_579133.validator(path, query, header, formData, body)
  let scheme = call_579133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579133.url(scheme.get, call_579133.host, call_579133.base,
                         call_579133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579133, url, valid)

proc call*(call_579134: Call_LoggingOrganizationsLogsList_579116; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## loggingOrganizationsLogsList
  ## Lists the logs in projects, organizations, folders, or billing accounts. Only logs that have entries are listed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of results to return from this request. Non-positive values are ignored. The presence of nextPageToken in the response indicates that more results might be available.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional. If present, then retrieve the next batch of results from the preceding call to this method. pageToken must be the value of nextPageToken from the previous response. The values of other method parameters should be identical to those in the previous call.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The resource name that owns the logs:
  ## "projects/[PROJECT_ID]"
  ## "organizations/[ORGANIZATION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]"
  ## "folders/[FOLDER_ID]"
  ## 
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579135 = newJObject()
  var query_579136 = newJObject()
  add(query_579136, "key", newJString(key))
  add(query_579136, "prettyPrint", newJBool(prettyPrint))
  add(query_579136, "oauth_token", newJString(oauthToken))
  add(query_579136, "$.xgafv", newJString(Xgafv))
  add(query_579136, "pageSize", newJInt(pageSize))
  add(query_579136, "alt", newJString(alt))
  add(query_579136, "uploadType", newJString(uploadType))
  add(query_579136, "quotaUser", newJString(quotaUser))
  add(query_579136, "pageToken", newJString(pageToken))
  add(query_579136, "callback", newJString(callback))
  add(path_579135, "parent", newJString(parent))
  add(query_579136, "fields", newJString(fields))
  add(query_579136, "access_token", newJString(accessToken))
  add(query_579136, "upload_protocol", newJString(uploadProtocol))
  result = call_579134.call(path_579135, query_579136, nil, nil, nil)

var loggingOrganizationsLogsList* = Call_LoggingOrganizationsLogsList_579116(
    name: "loggingOrganizationsLogsList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{parent}/logs",
    validator: validate_LoggingOrganizationsLogsList_579117, base: "/",
    url: url_LoggingOrganizationsLogsList_579118, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsCreate_579158 = ref object of OpenApiRestCall_578339
proc url_LoggingProjectsMetricsCreate_579160(protocol: Scheme; host: string;
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

proc validate_LoggingProjectsMetricsCreate_579159(path: JsonNode; query: JsonNode;
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
  var valid_579161 = path.getOrDefault("parent")
  valid_579161 = validateParameter(valid_579161, JString, required = true,
                                 default = nil)
  if valid_579161 != nil:
    section.add "parent", valid_579161
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579162 = query.getOrDefault("key")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "key", valid_579162
  var valid_579163 = query.getOrDefault("prettyPrint")
  valid_579163 = validateParameter(valid_579163, JBool, required = false,
                                 default = newJBool(true))
  if valid_579163 != nil:
    section.add "prettyPrint", valid_579163
  var valid_579164 = query.getOrDefault("oauth_token")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "oauth_token", valid_579164
  var valid_579165 = query.getOrDefault("$.xgafv")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = newJString("1"))
  if valid_579165 != nil:
    section.add "$.xgafv", valid_579165
  var valid_579166 = query.getOrDefault("alt")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = newJString("json"))
  if valid_579166 != nil:
    section.add "alt", valid_579166
  var valid_579167 = query.getOrDefault("uploadType")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "uploadType", valid_579167
  var valid_579168 = query.getOrDefault("quotaUser")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "quotaUser", valid_579168
  var valid_579169 = query.getOrDefault("callback")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "callback", valid_579169
  var valid_579170 = query.getOrDefault("fields")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "fields", valid_579170
  var valid_579171 = query.getOrDefault("access_token")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "access_token", valid_579171
  var valid_579172 = query.getOrDefault("upload_protocol")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "upload_protocol", valid_579172
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

proc call*(call_579174: Call_LoggingProjectsMetricsCreate_579158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a logs-based metric.
  ## 
  let valid = call_579174.validator(path, query, header, formData, body)
  let scheme = call_579174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579174.url(scheme.get, call_579174.host, call_579174.base,
                         call_579174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579174, url, valid)

proc call*(call_579175: Call_LoggingProjectsMetricsCreate_579158; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## loggingProjectsMetricsCreate
  ## Creates a logs-based metric.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The resource name of the project in which to create the metric:
  ## "projects/[PROJECT_ID]"
  ## The new metric must be provided in the request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579176 = newJObject()
  var query_579177 = newJObject()
  var body_579178 = newJObject()
  add(query_579177, "key", newJString(key))
  add(query_579177, "prettyPrint", newJBool(prettyPrint))
  add(query_579177, "oauth_token", newJString(oauthToken))
  add(query_579177, "$.xgafv", newJString(Xgafv))
  add(query_579177, "alt", newJString(alt))
  add(query_579177, "uploadType", newJString(uploadType))
  add(query_579177, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579178 = body
  add(query_579177, "callback", newJString(callback))
  add(path_579176, "parent", newJString(parent))
  add(query_579177, "fields", newJString(fields))
  add(query_579177, "access_token", newJString(accessToken))
  add(query_579177, "upload_protocol", newJString(uploadProtocol))
  result = call_579175.call(path_579176, query_579177, nil, nil, body_579178)

var loggingProjectsMetricsCreate* = Call_LoggingProjectsMetricsCreate_579158(
    name: "loggingProjectsMetricsCreate", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2/{parent}/metrics",
    validator: validate_LoggingProjectsMetricsCreate_579159, base: "/",
    url: url_LoggingProjectsMetricsCreate_579160, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsList_579137 = ref object of OpenApiRestCall_578339
proc url_LoggingProjectsMetricsList_579139(protocol: Scheme; host: string;
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

proc validate_LoggingProjectsMetricsList_579138(path: JsonNode; query: JsonNode;
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
  var valid_579140 = path.getOrDefault("parent")
  valid_579140 = validateParameter(valid_579140, JString, required = true,
                                 default = nil)
  if valid_579140 != nil:
    section.add "parent", valid_579140
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of results to return from this request. Non-positive values are ignored. The presence of nextPageToken in the response indicates that more results might be available.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional. If present, then retrieve the next batch of results from the preceding call to this method. pageToken must be the value of nextPageToken from the previous response. The values of other method parameters should be identical to those in the previous call.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579141 = query.getOrDefault("key")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "key", valid_579141
  var valid_579142 = query.getOrDefault("prettyPrint")
  valid_579142 = validateParameter(valid_579142, JBool, required = false,
                                 default = newJBool(true))
  if valid_579142 != nil:
    section.add "prettyPrint", valid_579142
  var valid_579143 = query.getOrDefault("oauth_token")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "oauth_token", valid_579143
  var valid_579144 = query.getOrDefault("$.xgafv")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = newJString("1"))
  if valid_579144 != nil:
    section.add "$.xgafv", valid_579144
  var valid_579145 = query.getOrDefault("pageSize")
  valid_579145 = validateParameter(valid_579145, JInt, required = false, default = nil)
  if valid_579145 != nil:
    section.add "pageSize", valid_579145
  var valid_579146 = query.getOrDefault("alt")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = newJString("json"))
  if valid_579146 != nil:
    section.add "alt", valid_579146
  var valid_579147 = query.getOrDefault("uploadType")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "uploadType", valid_579147
  var valid_579148 = query.getOrDefault("quotaUser")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "quotaUser", valid_579148
  var valid_579149 = query.getOrDefault("pageToken")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "pageToken", valid_579149
  var valid_579150 = query.getOrDefault("callback")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "callback", valid_579150
  var valid_579151 = query.getOrDefault("fields")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "fields", valid_579151
  var valid_579152 = query.getOrDefault("access_token")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "access_token", valid_579152
  var valid_579153 = query.getOrDefault("upload_protocol")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "upload_protocol", valid_579153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579154: Call_LoggingProjectsMetricsList_579137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists logs-based metrics.
  ## 
  let valid = call_579154.validator(path, query, header, formData, body)
  let scheme = call_579154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579154.url(scheme.get, call_579154.host, call_579154.base,
                         call_579154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579154, url, valid)

proc call*(call_579155: Call_LoggingProjectsMetricsList_579137; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## loggingProjectsMetricsList
  ## Lists logs-based metrics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of results to return from this request. Non-positive values are ignored. The presence of nextPageToken in the response indicates that more results might be available.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional. If present, then retrieve the next batch of results from the preceding call to this method. pageToken must be the value of nextPageToken from the previous response. The values of other method parameters should be identical to those in the previous call.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the project containing the metrics:
  ## "projects/[PROJECT_ID]"
  ## 
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579156 = newJObject()
  var query_579157 = newJObject()
  add(query_579157, "key", newJString(key))
  add(query_579157, "prettyPrint", newJBool(prettyPrint))
  add(query_579157, "oauth_token", newJString(oauthToken))
  add(query_579157, "$.xgafv", newJString(Xgafv))
  add(query_579157, "pageSize", newJInt(pageSize))
  add(query_579157, "alt", newJString(alt))
  add(query_579157, "uploadType", newJString(uploadType))
  add(query_579157, "quotaUser", newJString(quotaUser))
  add(query_579157, "pageToken", newJString(pageToken))
  add(query_579157, "callback", newJString(callback))
  add(path_579156, "parent", newJString(parent))
  add(query_579157, "fields", newJString(fields))
  add(query_579157, "access_token", newJString(accessToken))
  add(query_579157, "upload_protocol", newJString(uploadProtocol))
  result = call_579155.call(path_579156, query_579157, nil, nil, nil)

var loggingProjectsMetricsList* = Call_LoggingProjectsMetricsList_579137(
    name: "loggingProjectsMetricsList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{parent}/metrics",
    validator: validate_LoggingProjectsMetricsList_579138, base: "/",
    url: url_LoggingProjectsMetricsList_579139, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsSinksCreate_579200 = ref object of OpenApiRestCall_578339
proc url_LoggingOrganizationsSinksCreate_579202(protocol: Scheme; host: string;
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

proc validate_LoggingOrganizationsSinksCreate_579201(path: JsonNode;
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
  var valid_579203 = path.getOrDefault("parent")
  valid_579203 = validateParameter(valid_579203, JString, required = true,
                                 default = nil)
  if valid_579203 != nil:
    section.add "parent", valid_579203
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   uniqueWriterIdentity: JBool
  ##                       : Optional. Determines the kind of IAM identity returned as writer_identity in the new sink. If this value is omitted or set to false, and if the sink's parent is a project, then the value returned as writer_identity is the same group or service account used by Logging before the addition of writer identities to this API. The sink's destination must be in the same project as the sink itself.If this field is set to true, or if the sink is owned by a non-project resource such as an organization, then the value of writer_identity will be a unique service account used only for exports from the new sink. For more information, see writer_identity in LogSink.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579204 = query.getOrDefault("key")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "key", valid_579204
  var valid_579205 = query.getOrDefault("prettyPrint")
  valid_579205 = validateParameter(valid_579205, JBool, required = false,
                                 default = newJBool(true))
  if valid_579205 != nil:
    section.add "prettyPrint", valid_579205
  var valid_579206 = query.getOrDefault("oauth_token")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "oauth_token", valid_579206
  var valid_579207 = query.getOrDefault("$.xgafv")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = newJString("1"))
  if valid_579207 != nil:
    section.add "$.xgafv", valid_579207
  var valid_579208 = query.getOrDefault("alt")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = newJString("json"))
  if valid_579208 != nil:
    section.add "alt", valid_579208
  var valid_579209 = query.getOrDefault("uploadType")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "uploadType", valid_579209
  var valid_579210 = query.getOrDefault("quotaUser")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "quotaUser", valid_579210
  var valid_579211 = query.getOrDefault("uniqueWriterIdentity")
  valid_579211 = validateParameter(valid_579211, JBool, required = false, default = nil)
  if valid_579211 != nil:
    section.add "uniqueWriterIdentity", valid_579211
  var valid_579212 = query.getOrDefault("callback")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "callback", valid_579212
  var valid_579213 = query.getOrDefault("fields")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "fields", valid_579213
  var valid_579214 = query.getOrDefault("access_token")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "access_token", valid_579214
  var valid_579215 = query.getOrDefault("upload_protocol")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "upload_protocol", valid_579215
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

proc call*(call_579217: Call_LoggingOrganizationsSinksCreate_579200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a sink that exports specified log entries to a destination. The export of newly-ingested log entries begins immediately, unless the sink's writer_identity is not permitted to write to the destination. A sink can export log entries only from the resource owning the sink.
  ## 
  let valid = call_579217.validator(path, query, header, formData, body)
  let scheme = call_579217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579217.url(scheme.get, call_579217.host, call_579217.base,
                         call_579217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579217, url, valid)

proc call*(call_579218: Call_LoggingOrganizationsSinksCreate_579200;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = "";
          uniqueWriterIdentity: bool = false; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## loggingOrganizationsSinksCreate
  ## Creates a sink that exports specified log entries to a destination. The export of newly-ingested log entries begins immediately, unless the sink's writer_identity is not permitted to write to the destination. A sink can export log entries only from the resource owning the sink.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   uniqueWriterIdentity: bool
  ##                       : Optional. Determines the kind of IAM identity returned as writer_identity in the new sink. If this value is omitted or set to false, and if the sink's parent is a project, then the value returned as writer_identity is the same group or service account used by Logging before the addition of writer identities to this API. The sink's destination must be in the same project as the sink itself.If this field is set to true, or if the sink is owned by a non-project resource such as an organization, then the value of writer_identity will be a unique service account used only for exports from the new sink. For more information, see writer_identity in LogSink.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The resource in which to create the sink:
  ## "projects/[PROJECT_ID]"
  ## "organizations/[ORGANIZATION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]"
  ## "folders/[FOLDER_ID]"
  ## Examples: "projects/my-logging-project", "organizations/123456789".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579219 = newJObject()
  var query_579220 = newJObject()
  var body_579221 = newJObject()
  add(query_579220, "key", newJString(key))
  add(query_579220, "prettyPrint", newJBool(prettyPrint))
  add(query_579220, "oauth_token", newJString(oauthToken))
  add(query_579220, "$.xgafv", newJString(Xgafv))
  add(query_579220, "alt", newJString(alt))
  add(query_579220, "uploadType", newJString(uploadType))
  add(query_579220, "quotaUser", newJString(quotaUser))
  add(query_579220, "uniqueWriterIdentity", newJBool(uniqueWriterIdentity))
  if body != nil:
    body_579221 = body
  add(query_579220, "callback", newJString(callback))
  add(path_579219, "parent", newJString(parent))
  add(query_579220, "fields", newJString(fields))
  add(query_579220, "access_token", newJString(accessToken))
  add(query_579220, "upload_protocol", newJString(uploadProtocol))
  result = call_579218.call(path_579219, query_579220, nil, nil, body_579221)

var loggingOrganizationsSinksCreate* = Call_LoggingOrganizationsSinksCreate_579200(
    name: "loggingOrganizationsSinksCreate", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2/{parent}/sinks",
    validator: validate_LoggingOrganizationsSinksCreate_579201, base: "/",
    url: url_LoggingOrganizationsSinksCreate_579202, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsSinksList_579179 = ref object of OpenApiRestCall_578339
proc url_LoggingOrganizationsSinksList_579181(protocol: Scheme; host: string;
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

proc validate_LoggingOrganizationsSinksList_579180(path: JsonNode; query: JsonNode;
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
  var valid_579182 = path.getOrDefault("parent")
  valid_579182 = validateParameter(valid_579182, JString, required = true,
                                 default = nil)
  if valid_579182 != nil:
    section.add "parent", valid_579182
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of results to return from this request. Non-positive values are ignored. The presence of nextPageToken in the response indicates that more results might be available.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional. If present, then retrieve the next batch of results from the preceding call to this method. pageToken must be the value of nextPageToken from the previous response. The values of other method parameters should be identical to those in the previous call.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579183 = query.getOrDefault("key")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "key", valid_579183
  var valid_579184 = query.getOrDefault("prettyPrint")
  valid_579184 = validateParameter(valid_579184, JBool, required = false,
                                 default = newJBool(true))
  if valid_579184 != nil:
    section.add "prettyPrint", valid_579184
  var valid_579185 = query.getOrDefault("oauth_token")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "oauth_token", valid_579185
  var valid_579186 = query.getOrDefault("$.xgafv")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = newJString("1"))
  if valid_579186 != nil:
    section.add "$.xgafv", valid_579186
  var valid_579187 = query.getOrDefault("pageSize")
  valid_579187 = validateParameter(valid_579187, JInt, required = false, default = nil)
  if valid_579187 != nil:
    section.add "pageSize", valid_579187
  var valid_579188 = query.getOrDefault("alt")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = newJString("json"))
  if valid_579188 != nil:
    section.add "alt", valid_579188
  var valid_579189 = query.getOrDefault("uploadType")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "uploadType", valid_579189
  var valid_579190 = query.getOrDefault("quotaUser")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "quotaUser", valid_579190
  var valid_579191 = query.getOrDefault("pageToken")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "pageToken", valid_579191
  var valid_579192 = query.getOrDefault("callback")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "callback", valid_579192
  var valid_579193 = query.getOrDefault("fields")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "fields", valid_579193
  var valid_579194 = query.getOrDefault("access_token")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "access_token", valid_579194
  var valid_579195 = query.getOrDefault("upload_protocol")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "upload_protocol", valid_579195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579196: Call_LoggingOrganizationsSinksList_579179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists sinks.
  ## 
  let valid = call_579196.validator(path, query, header, formData, body)
  let scheme = call_579196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579196.url(scheme.get, call_579196.host, call_579196.base,
                         call_579196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579196, url, valid)

proc call*(call_579197: Call_LoggingOrganizationsSinksList_579179; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## loggingOrganizationsSinksList
  ## Lists sinks.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of results to return from this request. Non-positive values are ignored. The presence of nextPageToken in the response indicates that more results might be available.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional. If present, then retrieve the next batch of results from the preceding call to this method. pageToken must be the value of nextPageToken from the previous response. The values of other method parameters should be identical to those in the previous call.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The parent resource whose sinks are to be listed:
  ## "projects/[PROJECT_ID]"
  ## "organizations/[ORGANIZATION_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]"
  ## "folders/[FOLDER_ID]"
  ## 
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579198 = newJObject()
  var query_579199 = newJObject()
  add(query_579199, "key", newJString(key))
  add(query_579199, "prettyPrint", newJBool(prettyPrint))
  add(query_579199, "oauth_token", newJString(oauthToken))
  add(query_579199, "$.xgafv", newJString(Xgafv))
  add(query_579199, "pageSize", newJInt(pageSize))
  add(query_579199, "alt", newJString(alt))
  add(query_579199, "uploadType", newJString(uploadType))
  add(query_579199, "quotaUser", newJString(quotaUser))
  add(query_579199, "pageToken", newJString(pageToken))
  add(query_579199, "callback", newJString(callback))
  add(path_579198, "parent", newJString(parent))
  add(query_579199, "fields", newJString(fields))
  add(query_579199, "access_token", newJString(accessToken))
  add(query_579199, "upload_protocol", newJString(uploadProtocol))
  result = call_579197.call(path_579198, query_579199, nil, nil, nil)

var loggingOrganizationsSinksList* = Call_LoggingOrganizationsSinksList_579179(
    name: "loggingOrganizationsSinksList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{parent}/sinks",
    validator: validate_LoggingOrganizationsSinksList_579180, base: "/",
    url: url_LoggingOrganizationsSinksList_579181, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsSinksUpdate_579241 = ref object of OpenApiRestCall_578339
proc url_LoggingOrganizationsSinksUpdate_579243(protocol: Scheme; host: string;
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

proc validate_LoggingOrganizationsSinksUpdate_579242(path: JsonNode;
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
  var valid_579244 = path.getOrDefault("sinkName")
  valid_579244 = validateParameter(valid_579244, JString, required = true,
                                 default = nil)
  if valid_579244 != nil:
    section.add "sinkName", valid_579244
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : Optional. Field mask that specifies the fields in sink that need an update. A sink field will be overwritten if, and only if, it is in the update mask. name and output only fields cannot be updated.An empty updateMask is temporarily treated as using the following mask for backwards compatibility purposes:  destination,filter,includeChildren At some point in the future, behavior will be removed and specifying an empty updateMask will be an error.For a detailed FieldMask definition, see 
  ## https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#google.protobuf.FieldMaskExample: updateMask=filter.
  ##   uniqueWriterIdentity: JBool
  ##                       : Optional. See sinks.create for a description of this field. When updating a sink, the effect of this field on the value of writer_identity in the updated sink depends on both the old and new values of this field:
  ## If the old and new values of this field are both false or both true, then there is no change to the sink's writer_identity.
  ## If the old value is false and the new value is true, then writer_identity is changed to a unique service account.
  ## It is an error if the old value is true and the new value is set to false or defaulted to false.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579245 = query.getOrDefault("key")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = nil)
  if valid_579245 != nil:
    section.add "key", valid_579245
  var valid_579246 = query.getOrDefault("prettyPrint")
  valid_579246 = validateParameter(valid_579246, JBool, required = false,
                                 default = newJBool(true))
  if valid_579246 != nil:
    section.add "prettyPrint", valid_579246
  var valid_579247 = query.getOrDefault("oauth_token")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "oauth_token", valid_579247
  var valid_579248 = query.getOrDefault("$.xgafv")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = newJString("1"))
  if valid_579248 != nil:
    section.add "$.xgafv", valid_579248
  var valid_579249 = query.getOrDefault("alt")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = newJString("json"))
  if valid_579249 != nil:
    section.add "alt", valid_579249
  var valid_579250 = query.getOrDefault("uploadType")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "uploadType", valid_579250
  var valid_579251 = query.getOrDefault("quotaUser")
  valid_579251 = validateParameter(valid_579251, JString, required = false,
                                 default = nil)
  if valid_579251 != nil:
    section.add "quotaUser", valid_579251
  var valid_579252 = query.getOrDefault("updateMask")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "updateMask", valid_579252
  var valid_579253 = query.getOrDefault("uniqueWriterIdentity")
  valid_579253 = validateParameter(valid_579253, JBool, required = false, default = nil)
  if valid_579253 != nil:
    section.add "uniqueWriterIdentity", valid_579253
  var valid_579254 = query.getOrDefault("callback")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = nil)
  if valid_579254 != nil:
    section.add "callback", valid_579254
  var valid_579255 = query.getOrDefault("fields")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "fields", valid_579255
  var valid_579256 = query.getOrDefault("access_token")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "access_token", valid_579256
  var valid_579257 = query.getOrDefault("upload_protocol")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "upload_protocol", valid_579257
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

proc call*(call_579259: Call_LoggingOrganizationsSinksUpdate_579241;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a sink. This method replaces the following fields in the existing sink with values from the new sink: destination, and filter.The updated sink might also have a new writer_identity; see the unique_writer_identity field.
  ## 
  let valid = call_579259.validator(path, query, header, formData, body)
  let scheme = call_579259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579259.url(scheme.get, call_579259.host, call_579259.base,
                         call_579259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579259, url, valid)

proc call*(call_579260: Call_LoggingOrganizationsSinksUpdate_579241;
          sinkName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          uniqueWriterIdentity: bool = false; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## loggingOrganizationsSinksUpdate
  ## Updates a sink. This method replaces the following fields in the existing sink with values from the new sink: destination, and filter.The updated sink might also have a new writer_identity; see the unique_writer_identity field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: string
  ##             : Optional. Field mask that specifies the fields in sink that need an update. A sink field will be overwritten if, and only if, it is in the update mask. name and output only fields cannot be updated.An empty updateMask is temporarily treated as using the following mask for backwards compatibility purposes:  destination,filter,includeChildren At some point in the future, behavior will be removed and specifying an empty updateMask will be an error.For a detailed FieldMask definition, see 
  ## https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#google.protobuf.FieldMaskExample: updateMask=filter.
  ##   sinkName: string (required)
  ##           : Required. The full resource name of the sink to update, including the parent resource and the sink identifier:
  ## "projects/[PROJECT_ID]/sinks/[SINK_ID]"
  ## "organizations/[ORGANIZATION_ID]/sinks/[SINK_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/sinks/[SINK_ID]"
  ## "folders/[FOLDER_ID]/sinks/[SINK_ID]"
  ## Example: "projects/my-project-id/sinks/my-sink-id".
  ##   uniqueWriterIdentity: bool
  ##                       : Optional. See sinks.create for a description of this field. When updating a sink, the effect of this field on the value of writer_identity in the updated sink depends on both the old and new values of this field:
  ## If the old and new values of this field are both false or both true, then there is no change to the sink's writer_identity.
  ## If the old value is false and the new value is true, then writer_identity is changed to a unique service account.
  ## It is an error if the old value is true and the new value is set to false or defaulted to false.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579261 = newJObject()
  var query_579262 = newJObject()
  var body_579263 = newJObject()
  add(query_579262, "key", newJString(key))
  add(query_579262, "prettyPrint", newJBool(prettyPrint))
  add(query_579262, "oauth_token", newJString(oauthToken))
  add(query_579262, "$.xgafv", newJString(Xgafv))
  add(query_579262, "alt", newJString(alt))
  add(query_579262, "uploadType", newJString(uploadType))
  add(query_579262, "quotaUser", newJString(quotaUser))
  add(query_579262, "updateMask", newJString(updateMask))
  add(path_579261, "sinkName", newJString(sinkName))
  add(query_579262, "uniqueWriterIdentity", newJBool(uniqueWriterIdentity))
  if body != nil:
    body_579263 = body
  add(query_579262, "callback", newJString(callback))
  add(query_579262, "fields", newJString(fields))
  add(query_579262, "access_token", newJString(accessToken))
  add(query_579262, "upload_protocol", newJString(uploadProtocol))
  result = call_579260.call(path_579261, query_579262, nil, nil, body_579263)

var loggingOrganizationsSinksUpdate* = Call_LoggingOrganizationsSinksUpdate_579241(
    name: "loggingOrganizationsSinksUpdate", meth: HttpMethod.HttpPut,
    host: "logging.googleapis.com", route: "/v2/{sinkName}",
    validator: validate_LoggingOrganizationsSinksUpdate_579242, base: "/",
    url: url_LoggingOrganizationsSinksUpdate_579243, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsSinksGet_579222 = ref object of OpenApiRestCall_578339
proc url_LoggingOrganizationsSinksGet_579224(protocol: Scheme; host: string;
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

proc validate_LoggingOrganizationsSinksGet_579223(path: JsonNode; query: JsonNode;
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
  var valid_579225 = path.getOrDefault("sinkName")
  valid_579225 = validateParameter(valid_579225, JString, required = true,
                                 default = nil)
  if valid_579225 != nil:
    section.add "sinkName", valid_579225
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579226 = query.getOrDefault("key")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "key", valid_579226
  var valid_579227 = query.getOrDefault("prettyPrint")
  valid_579227 = validateParameter(valid_579227, JBool, required = false,
                                 default = newJBool(true))
  if valid_579227 != nil:
    section.add "prettyPrint", valid_579227
  var valid_579228 = query.getOrDefault("oauth_token")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = nil)
  if valid_579228 != nil:
    section.add "oauth_token", valid_579228
  var valid_579229 = query.getOrDefault("$.xgafv")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = newJString("1"))
  if valid_579229 != nil:
    section.add "$.xgafv", valid_579229
  var valid_579230 = query.getOrDefault("alt")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = newJString("json"))
  if valid_579230 != nil:
    section.add "alt", valid_579230
  var valid_579231 = query.getOrDefault("uploadType")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "uploadType", valid_579231
  var valid_579232 = query.getOrDefault("quotaUser")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "quotaUser", valid_579232
  var valid_579233 = query.getOrDefault("callback")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "callback", valid_579233
  var valid_579234 = query.getOrDefault("fields")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = nil)
  if valid_579234 != nil:
    section.add "fields", valid_579234
  var valid_579235 = query.getOrDefault("access_token")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "access_token", valid_579235
  var valid_579236 = query.getOrDefault("upload_protocol")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "upload_protocol", valid_579236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579237: Call_LoggingOrganizationsSinksGet_579222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a sink.
  ## 
  let valid = call_579237.validator(path, query, header, formData, body)
  let scheme = call_579237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579237.url(scheme.get, call_579237.host, call_579237.base,
                         call_579237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579237, url, valid)

proc call*(call_579238: Call_LoggingOrganizationsSinksGet_579222; sinkName: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## loggingOrganizationsSinksGet
  ## Gets a sink.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   sinkName: string (required)
  ##           : Required. The resource name of the sink:
  ## "projects/[PROJECT_ID]/sinks/[SINK_ID]"
  ## "organizations/[ORGANIZATION_ID]/sinks/[SINK_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/sinks/[SINK_ID]"
  ## "folders/[FOLDER_ID]/sinks/[SINK_ID]"
  ## Example: "projects/my-project-id/sinks/my-sink-id".
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579239 = newJObject()
  var query_579240 = newJObject()
  add(query_579240, "key", newJString(key))
  add(query_579240, "prettyPrint", newJBool(prettyPrint))
  add(query_579240, "oauth_token", newJString(oauthToken))
  add(query_579240, "$.xgafv", newJString(Xgafv))
  add(query_579240, "alt", newJString(alt))
  add(query_579240, "uploadType", newJString(uploadType))
  add(query_579240, "quotaUser", newJString(quotaUser))
  add(path_579239, "sinkName", newJString(sinkName))
  add(query_579240, "callback", newJString(callback))
  add(query_579240, "fields", newJString(fields))
  add(query_579240, "access_token", newJString(accessToken))
  add(query_579240, "upload_protocol", newJString(uploadProtocol))
  result = call_579238.call(path_579239, query_579240, nil, nil, nil)

var loggingOrganizationsSinksGet* = Call_LoggingOrganizationsSinksGet_579222(
    name: "loggingOrganizationsSinksGet", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2/{sinkName}",
    validator: validate_LoggingOrganizationsSinksGet_579223, base: "/",
    url: url_LoggingOrganizationsSinksGet_579224, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsSinksPatch_579283 = ref object of OpenApiRestCall_578339
proc url_LoggingOrganizationsSinksPatch_579285(protocol: Scheme; host: string;
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

proc validate_LoggingOrganizationsSinksPatch_579284(path: JsonNode;
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
  var valid_579286 = path.getOrDefault("sinkName")
  valid_579286 = validateParameter(valid_579286, JString, required = true,
                                 default = nil)
  if valid_579286 != nil:
    section.add "sinkName", valid_579286
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : Optional. Field mask that specifies the fields in sink that need an update. A sink field will be overwritten if, and only if, it is in the update mask. name and output only fields cannot be updated.An empty updateMask is temporarily treated as using the following mask for backwards compatibility purposes:  destination,filter,includeChildren At some point in the future, behavior will be removed and specifying an empty updateMask will be an error.For a detailed FieldMask definition, see 
  ## https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#google.protobuf.FieldMaskExample: updateMask=filter.
  ##   uniqueWriterIdentity: JBool
  ##                       : Optional. See sinks.create for a description of this field. When updating a sink, the effect of this field on the value of writer_identity in the updated sink depends on both the old and new values of this field:
  ## If the old and new values of this field are both false or both true, then there is no change to the sink's writer_identity.
  ## If the old value is false and the new value is true, then writer_identity is changed to a unique service account.
  ## It is an error if the old value is true and the new value is set to false or defaulted to false.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579287 = query.getOrDefault("key")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = nil)
  if valid_579287 != nil:
    section.add "key", valid_579287
  var valid_579288 = query.getOrDefault("prettyPrint")
  valid_579288 = validateParameter(valid_579288, JBool, required = false,
                                 default = newJBool(true))
  if valid_579288 != nil:
    section.add "prettyPrint", valid_579288
  var valid_579289 = query.getOrDefault("oauth_token")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = nil)
  if valid_579289 != nil:
    section.add "oauth_token", valid_579289
  var valid_579290 = query.getOrDefault("$.xgafv")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = newJString("1"))
  if valid_579290 != nil:
    section.add "$.xgafv", valid_579290
  var valid_579291 = query.getOrDefault("alt")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = newJString("json"))
  if valid_579291 != nil:
    section.add "alt", valid_579291
  var valid_579292 = query.getOrDefault("uploadType")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "uploadType", valid_579292
  var valid_579293 = query.getOrDefault("quotaUser")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "quotaUser", valid_579293
  var valid_579294 = query.getOrDefault("updateMask")
  valid_579294 = validateParameter(valid_579294, JString, required = false,
                                 default = nil)
  if valid_579294 != nil:
    section.add "updateMask", valid_579294
  var valid_579295 = query.getOrDefault("uniqueWriterIdentity")
  valid_579295 = validateParameter(valid_579295, JBool, required = false, default = nil)
  if valid_579295 != nil:
    section.add "uniqueWriterIdentity", valid_579295
  var valid_579296 = query.getOrDefault("callback")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "callback", valid_579296
  var valid_579297 = query.getOrDefault("fields")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = nil)
  if valid_579297 != nil:
    section.add "fields", valid_579297
  var valid_579298 = query.getOrDefault("access_token")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "access_token", valid_579298
  var valid_579299 = query.getOrDefault("upload_protocol")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "upload_protocol", valid_579299
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

proc call*(call_579301: Call_LoggingOrganizationsSinksPatch_579283; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a sink. This method replaces the following fields in the existing sink with values from the new sink: destination, and filter.The updated sink might also have a new writer_identity; see the unique_writer_identity field.
  ## 
  let valid = call_579301.validator(path, query, header, formData, body)
  let scheme = call_579301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579301.url(scheme.get, call_579301.host, call_579301.base,
                         call_579301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579301, url, valid)

proc call*(call_579302: Call_LoggingOrganizationsSinksPatch_579283;
          sinkName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          uniqueWriterIdentity: bool = false; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## loggingOrganizationsSinksPatch
  ## Updates a sink. This method replaces the following fields in the existing sink with values from the new sink: destination, and filter.The updated sink might also have a new writer_identity; see the unique_writer_identity field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: string
  ##             : Optional. Field mask that specifies the fields in sink that need an update. A sink field will be overwritten if, and only if, it is in the update mask. name and output only fields cannot be updated.An empty updateMask is temporarily treated as using the following mask for backwards compatibility purposes:  destination,filter,includeChildren At some point in the future, behavior will be removed and specifying an empty updateMask will be an error.For a detailed FieldMask definition, see 
  ## https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#google.protobuf.FieldMaskExample: updateMask=filter.
  ##   sinkName: string (required)
  ##           : Required. The full resource name of the sink to update, including the parent resource and the sink identifier:
  ## "projects/[PROJECT_ID]/sinks/[SINK_ID]"
  ## "organizations/[ORGANIZATION_ID]/sinks/[SINK_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/sinks/[SINK_ID]"
  ## "folders/[FOLDER_ID]/sinks/[SINK_ID]"
  ## Example: "projects/my-project-id/sinks/my-sink-id".
  ##   uniqueWriterIdentity: bool
  ##                       : Optional. See sinks.create for a description of this field. When updating a sink, the effect of this field on the value of writer_identity in the updated sink depends on both the old and new values of this field:
  ## If the old and new values of this field are both false or both true, then there is no change to the sink's writer_identity.
  ## If the old value is false and the new value is true, then writer_identity is changed to a unique service account.
  ## It is an error if the old value is true and the new value is set to false or defaulted to false.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579303 = newJObject()
  var query_579304 = newJObject()
  var body_579305 = newJObject()
  add(query_579304, "key", newJString(key))
  add(query_579304, "prettyPrint", newJBool(prettyPrint))
  add(query_579304, "oauth_token", newJString(oauthToken))
  add(query_579304, "$.xgafv", newJString(Xgafv))
  add(query_579304, "alt", newJString(alt))
  add(query_579304, "uploadType", newJString(uploadType))
  add(query_579304, "quotaUser", newJString(quotaUser))
  add(query_579304, "updateMask", newJString(updateMask))
  add(path_579303, "sinkName", newJString(sinkName))
  add(query_579304, "uniqueWriterIdentity", newJBool(uniqueWriterIdentity))
  if body != nil:
    body_579305 = body
  add(query_579304, "callback", newJString(callback))
  add(query_579304, "fields", newJString(fields))
  add(query_579304, "access_token", newJString(accessToken))
  add(query_579304, "upload_protocol", newJString(uploadProtocol))
  result = call_579302.call(path_579303, query_579304, nil, nil, body_579305)

var loggingOrganizationsSinksPatch* = Call_LoggingOrganizationsSinksPatch_579283(
    name: "loggingOrganizationsSinksPatch", meth: HttpMethod.HttpPatch,
    host: "logging.googleapis.com", route: "/v2/{sinkName}",
    validator: validate_LoggingOrganizationsSinksPatch_579284, base: "/",
    url: url_LoggingOrganizationsSinksPatch_579285, schemes: {Scheme.Https})
type
  Call_LoggingOrganizationsSinksDelete_579264 = ref object of OpenApiRestCall_578339
proc url_LoggingOrganizationsSinksDelete_579266(protocol: Scheme; host: string;
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

proc validate_LoggingOrganizationsSinksDelete_579265(path: JsonNode;
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
  var valid_579267 = path.getOrDefault("sinkName")
  valid_579267 = validateParameter(valid_579267, JString, required = true,
                                 default = nil)
  if valid_579267 != nil:
    section.add "sinkName", valid_579267
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579268 = query.getOrDefault("key")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "key", valid_579268
  var valid_579269 = query.getOrDefault("prettyPrint")
  valid_579269 = validateParameter(valid_579269, JBool, required = false,
                                 default = newJBool(true))
  if valid_579269 != nil:
    section.add "prettyPrint", valid_579269
  var valid_579270 = query.getOrDefault("oauth_token")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "oauth_token", valid_579270
  var valid_579271 = query.getOrDefault("$.xgafv")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = newJString("1"))
  if valid_579271 != nil:
    section.add "$.xgafv", valid_579271
  var valid_579272 = query.getOrDefault("alt")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = newJString("json"))
  if valid_579272 != nil:
    section.add "alt", valid_579272
  var valid_579273 = query.getOrDefault("uploadType")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = nil)
  if valid_579273 != nil:
    section.add "uploadType", valid_579273
  var valid_579274 = query.getOrDefault("quotaUser")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "quotaUser", valid_579274
  var valid_579275 = query.getOrDefault("callback")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = nil)
  if valid_579275 != nil:
    section.add "callback", valid_579275
  var valid_579276 = query.getOrDefault("fields")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "fields", valid_579276
  var valid_579277 = query.getOrDefault("access_token")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "access_token", valid_579277
  var valid_579278 = query.getOrDefault("upload_protocol")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = nil)
  if valid_579278 != nil:
    section.add "upload_protocol", valid_579278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579279: Call_LoggingOrganizationsSinksDelete_579264;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a sink. If the sink has a unique writer_identity, then that service account is also deleted.
  ## 
  let valid = call_579279.validator(path, query, header, formData, body)
  let scheme = call_579279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579279.url(scheme.get, call_579279.host, call_579279.base,
                         call_579279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579279, url, valid)

proc call*(call_579280: Call_LoggingOrganizationsSinksDelete_579264;
          sinkName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## loggingOrganizationsSinksDelete
  ## Deletes a sink. If the sink has a unique writer_identity, then that service account is also deleted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   sinkName: string (required)
  ##           : Required. The full resource name of the sink to delete, including the parent resource and the sink identifier:
  ## "projects/[PROJECT_ID]/sinks/[SINK_ID]"
  ## "organizations/[ORGANIZATION_ID]/sinks/[SINK_ID]"
  ## "billingAccounts/[BILLING_ACCOUNT_ID]/sinks/[SINK_ID]"
  ## "folders/[FOLDER_ID]/sinks/[SINK_ID]"
  ## Example: "projects/my-project-id/sinks/my-sink-id".
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579281 = newJObject()
  var query_579282 = newJObject()
  add(query_579282, "key", newJString(key))
  add(query_579282, "prettyPrint", newJBool(prettyPrint))
  add(query_579282, "oauth_token", newJString(oauthToken))
  add(query_579282, "$.xgafv", newJString(Xgafv))
  add(query_579282, "alt", newJString(alt))
  add(query_579282, "uploadType", newJString(uploadType))
  add(query_579282, "quotaUser", newJString(quotaUser))
  add(path_579281, "sinkName", newJString(sinkName))
  add(query_579282, "callback", newJString(callback))
  add(query_579282, "fields", newJString(fields))
  add(query_579282, "access_token", newJString(accessToken))
  add(query_579282, "upload_protocol", newJString(uploadProtocol))
  result = call_579280.call(path_579281, query_579282, nil, nil, nil)

var loggingOrganizationsSinksDelete* = Call_LoggingOrganizationsSinksDelete_579264(
    name: "loggingOrganizationsSinksDelete", meth: HttpMethod.HttpDelete,
    host: "logging.googleapis.com", route: "/v2/{sinkName}",
    validator: validate_LoggingOrganizationsSinksDelete_579265, base: "/",
    url: url_LoggingOrganizationsSinksDelete_579266, schemes: {Scheme.Https})
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
