
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
    host: "logging.googleapis.com", route: "/v2beta1/entries:list",
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
    host: "logging.googleapis.com", route: "/v2beta1/entries:write",
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
    host: "logging.googleapis.com",
    route: "/v2beta1/monitoredResourceDescriptors",
    validator: validate_LoggingMonitoredResourceDescriptorsList_578904, base: "/",
    url: url_LoggingMonitoredResourceDescriptorsList_578905,
    schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsUpdate_578955 = ref object of OpenApiRestCall_578339
proc url_LoggingProjectsMetricsUpdate_578957(protocol: Scheme; host: string;
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

proc validate_LoggingProjectsMetricsUpdate_578956(path: JsonNode; query: JsonNode;
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578971: Call_LoggingProjectsMetricsUpdate_578955; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a logs-based metric.
  ## 
  let valid = call_578971.validator(path, query, header, formData, body)
  let scheme = call_578971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578971.url(scheme.get, call_578971.host, call_578971.base,
                         call_578971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578971, url, valid)

proc call*(call_578972: Call_LoggingProjectsMetricsUpdate_578955;
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
  var path_578973 = newJObject()
  var query_578974 = newJObject()
  var body_578975 = newJObject()
  add(query_578974, "key", newJString(key))
  add(query_578974, "prettyPrint", newJBool(prettyPrint))
  add(query_578974, "oauth_token", newJString(oauthToken))
  add(query_578974, "$.xgafv", newJString(Xgafv))
  add(query_578974, "alt", newJString(alt))
  add(query_578974, "uploadType", newJString(uploadType))
  add(query_578974, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578975 = body
  add(query_578974, "callback", newJString(callback))
  add(path_578973, "metricName", newJString(metricName))
  add(query_578974, "fields", newJString(fields))
  add(query_578974, "access_token", newJString(accessToken))
  add(query_578974, "upload_protocol", newJString(uploadProtocol))
  result = call_578972.call(path_578973, query_578974, nil, nil, body_578975)

var loggingProjectsMetricsUpdate* = Call_LoggingProjectsMetricsUpdate_578955(
    name: "loggingProjectsMetricsUpdate", meth: HttpMethod.HttpPut,
    host: "logging.googleapis.com", route: "/v2beta1/{metricName}",
    validator: validate_LoggingProjectsMetricsUpdate_578956, base: "/",
    url: url_LoggingProjectsMetricsUpdate_578957, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsGet_578922 = ref object of OpenApiRestCall_578339
proc url_LoggingProjectsMetricsGet_578924(protocol: Scheme; host: string;
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

proc validate_LoggingProjectsMetricsGet_578923(path: JsonNode; query: JsonNode;
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
  var valid_578939 = path.getOrDefault("metricName")
  valid_578939 = validateParameter(valid_578939, JString, required = true,
                                 default = nil)
  if valid_578939 != nil:
    section.add "metricName", valid_578939
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

proc call*(call_578951: Call_LoggingProjectsMetricsGet_578922; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a logs-based metric.
  ## 
  let valid = call_578951.validator(path, query, header, formData, body)
  let scheme = call_578951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578951.url(scheme.get, call_578951.host, call_578951.base,
                         call_578951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578951, url, valid)

proc call*(call_578952: Call_LoggingProjectsMetricsGet_578922; metricName: string;
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
  var path_578953 = newJObject()
  var query_578954 = newJObject()
  add(query_578954, "key", newJString(key))
  add(query_578954, "prettyPrint", newJBool(prettyPrint))
  add(query_578954, "oauth_token", newJString(oauthToken))
  add(query_578954, "$.xgafv", newJString(Xgafv))
  add(query_578954, "alt", newJString(alt))
  add(query_578954, "uploadType", newJString(uploadType))
  add(query_578954, "quotaUser", newJString(quotaUser))
  add(query_578954, "callback", newJString(callback))
  add(path_578953, "metricName", newJString(metricName))
  add(query_578954, "fields", newJString(fields))
  add(query_578954, "access_token", newJString(accessToken))
  add(query_578954, "upload_protocol", newJString(uploadProtocol))
  result = call_578952.call(path_578953, query_578954, nil, nil, nil)

var loggingProjectsMetricsGet* = Call_LoggingProjectsMetricsGet_578922(
    name: "loggingProjectsMetricsGet", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2beta1/{metricName}",
    validator: validate_LoggingProjectsMetricsGet_578923, base: "/",
    url: url_LoggingProjectsMetricsGet_578924, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsDelete_578976 = ref object of OpenApiRestCall_578339
proc url_LoggingProjectsMetricsDelete_578978(protocol: Scheme; host: string;
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

proc validate_LoggingProjectsMetricsDelete_578977(path: JsonNode; query: JsonNode;
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
  var valid_578979 = path.getOrDefault("metricName")
  valid_578979 = validateParameter(valid_578979, JString, required = true,
                                 default = nil)
  if valid_578979 != nil:
    section.add "metricName", valid_578979
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
  var valid_578980 = query.getOrDefault("key")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "key", valid_578980
  var valid_578981 = query.getOrDefault("prettyPrint")
  valid_578981 = validateParameter(valid_578981, JBool, required = false,
                                 default = newJBool(true))
  if valid_578981 != nil:
    section.add "prettyPrint", valid_578981
  var valid_578982 = query.getOrDefault("oauth_token")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "oauth_token", valid_578982
  var valid_578983 = query.getOrDefault("$.xgafv")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = newJString("1"))
  if valid_578983 != nil:
    section.add "$.xgafv", valid_578983
  var valid_578984 = query.getOrDefault("alt")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = newJString("json"))
  if valid_578984 != nil:
    section.add "alt", valid_578984
  var valid_578985 = query.getOrDefault("uploadType")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "uploadType", valid_578985
  var valid_578986 = query.getOrDefault("quotaUser")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "quotaUser", valid_578986
  var valid_578987 = query.getOrDefault("callback")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "callback", valid_578987
  var valid_578988 = query.getOrDefault("fields")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "fields", valid_578988
  var valid_578989 = query.getOrDefault("access_token")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "access_token", valid_578989
  var valid_578990 = query.getOrDefault("upload_protocol")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "upload_protocol", valid_578990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578991: Call_LoggingProjectsMetricsDelete_578976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a logs-based metric.
  ## 
  let valid = call_578991.validator(path, query, header, formData, body)
  let scheme = call_578991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578991.url(scheme.get, call_578991.host, call_578991.base,
                         call_578991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578991, url, valid)

proc call*(call_578992: Call_LoggingProjectsMetricsDelete_578976;
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
  var path_578993 = newJObject()
  var query_578994 = newJObject()
  add(query_578994, "key", newJString(key))
  add(query_578994, "prettyPrint", newJBool(prettyPrint))
  add(query_578994, "oauth_token", newJString(oauthToken))
  add(query_578994, "$.xgafv", newJString(Xgafv))
  add(query_578994, "alt", newJString(alt))
  add(query_578994, "uploadType", newJString(uploadType))
  add(query_578994, "quotaUser", newJString(quotaUser))
  add(query_578994, "callback", newJString(callback))
  add(path_578993, "metricName", newJString(metricName))
  add(query_578994, "fields", newJString(fields))
  add(query_578994, "access_token", newJString(accessToken))
  add(query_578994, "upload_protocol", newJString(uploadProtocol))
  result = call_578992.call(path_578993, query_578994, nil, nil, nil)

var loggingProjectsMetricsDelete* = Call_LoggingProjectsMetricsDelete_578976(
    name: "loggingProjectsMetricsDelete", meth: HttpMethod.HttpDelete,
    host: "logging.googleapis.com", route: "/v2beta1/{metricName}",
    validator: validate_LoggingProjectsMetricsDelete_578977, base: "/",
    url: url_LoggingProjectsMetricsDelete_578978, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsCreate_579016 = ref object of OpenApiRestCall_578339
proc url_LoggingProjectsMetricsCreate_579018(protocol: Scheme; host: string;
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

proc validate_LoggingProjectsMetricsCreate_579017(path: JsonNode; query: JsonNode;
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
  var valid_579019 = path.getOrDefault("parent")
  valid_579019 = validateParameter(valid_579019, JString, required = true,
                                 default = nil)
  if valid_579019 != nil:
    section.add "parent", valid_579019
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
  var valid_579020 = query.getOrDefault("key")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "key", valid_579020
  var valid_579021 = query.getOrDefault("prettyPrint")
  valid_579021 = validateParameter(valid_579021, JBool, required = false,
                                 default = newJBool(true))
  if valid_579021 != nil:
    section.add "prettyPrint", valid_579021
  var valid_579022 = query.getOrDefault("oauth_token")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "oauth_token", valid_579022
  var valid_579023 = query.getOrDefault("$.xgafv")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = newJString("1"))
  if valid_579023 != nil:
    section.add "$.xgafv", valid_579023
  var valid_579024 = query.getOrDefault("alt")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = newJString("json"))
  if valid_579024 != nil:
    section.add "alt", valid_579024
  var valid_579025 = query.getOrDefault("uploadType")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "uploadType", valid_579025
  var valid_579026 = query.getOrDefault("quotaUser")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "quotaUser", valid_579026
  var valid_579027 = query.getOrDefault("callback")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "callback", valid_579027
  var valid_579028 = query.getOrDefault("fields")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "fields", valid_579028
  var valid_579029 = query.getOrDefault("access_token")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "access_token", valid_579029
  var valid_579030 = query.getOrDefault("upload_protocol")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "upload_protocol", valid_579030
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

proc call*(call_579032: Call_LoggingProjectsMetricsCreate_579016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a logs-based metric.
  ## 
  let valid = call_579032.validator(path, query, header, formData, body)
  let scheme = call_579032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579032.url(scheme.get, call_579032.host, call_579032.base,
                         call_579032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579032, url, valid)

proc call*(call_579033: Call_LoggingProjectsMetricsCreate_579016; parent: string;
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
  var path_579034 = newJObject()
  var query_579035 = newJObject()
  var body_579036 = newJObject()
  add(query_579035, "key", newJString(key))
  add(query_579035, "prettyPrint", newJBool(prettyPrint))
  add(query_579035, "oauth_token", newJString(oauthToken))
  add(query_579035, "$.xgafv", newJString(Xgafv))
  add(query_579035, "alt", newJString(alt))
  add(query_579035, "uploadType", newJString(uploadType))
  add(query_579035, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579036 = body
  add(query_579035, "callback", newJString(callback))
  add(path_579034, "parent", newJString(parent))
  add(query_579035, "fields", newJString(fields))
  add(query_579035, "access_token", newJString(accessToken))
  add(query_579035, "upload_protocol", newJString(uploadProtocol))
  result = call_579033.call(path_579034, query_579035, nil, nil, body_579036)

var loggingProjectsMetricsCreate* = Call_LoggingProjectsMetricsCreate_579016(
    name: "loggingProjectsMetricsCreate", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2beta1/{parent}/metrics",
    validator: validate_LoggingProjectsMetricsCreate_579017, base: "/",
    url: url_LoggingProjectsMetricsCreate_579018, schemes: {Scheme.Https})
type
  Call_LoggingProjectsMetricsList_578995 = ref object of OpenApiRestCall_578339
proc url_LoggingProjectsMetricsList_578997(protocol: Scheme; host: string;
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

proc validate_LoggingProjectsMetricsList_578996(path: JsonNode; query: JsonNode;
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
  var valid_578998 = path.getOrDefault("parent")
  valid_578998 = validateParameter(valid_578998, JString, required = true,
                                 default = nil)
  if valid_578998 != nil:
    section.add "parent", valid_578998
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
  var valid_579003 = query.getOrDefault("pageSize")
  valid_579003 = validateParameter(valid_579003, JInt, required = false, default = nil)
  if valid_579003 != nil:
    section.add "pageSize", valid_579003
  var valid_579004 = query.getOrDefault("alt")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = newJString("json"))
  if valid_579004 != nil:
    section.add "alt", valid_579004
  var valid_579005 = query.getOrDefault("uploadType")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "uploadType", valid_579005
  var valid_579006 = query.getOrDefault("quotaUser")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "quotaUser", valid_579006
  var valid_579007 = query.getOrDefault("pageToken")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "pageToken", valid_579007
  var valid_579008 = query.getOrDefault("callback")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "callback", valid_579008
  var valid_579009 = query.getOrDefault("fields")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "fields", valid_579009
  var valid_579010 = query.getOrDefault("access_token")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "access_token", valid_579010
  var valid_579011 = query.getOrDefault("upload_protocol")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "upload_protocol", valid_579011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579012: Call_LoggingProjectsMetricsList_578995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists logs-based metrics.
  ## 
  let valid = call_579012.validator(path, query, header, formData, body)
  let scheme = call_579012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579012.url(scheme.get, call_579012.host, call_579012.base,
                         call_579012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579012, url, valid)

proc call*(call_579013: Call_LoggingProjectsMetricsList_578995; parent: string;
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
  var path_579014 = newJObject()
  var query_579015 = newJObject()
  add(query_579015, "key", newJString(key))
  add(query_579015, "prettyPrint", newJBool(prettyPrint))
  add(query_579015, "oauth_token", newJString(oauthToken))
  add(query_579015, "$.xgafv", newJString(Xgafv))
  add(query_579015, "pageSize", newJInt(pageSize))
  add(query_579015, "alt", newJString(alt))
  add(query_579015, "uploadType", newJString(uploadType))
  add(query_579015, "quotaUser", newJString(quotaUser))
  add(query_579015, "pageToken", newJString(pageToken))
  add(query_579015, "callback", newJString(callback))
  add(path_579014, "parent", newJString(parent))
  add(query_579015, "fields", newJString(fields))
  add(query_579015, "access_token", newJString(accessToken))
  add(query_579015, "upload_protocol", newJString(uploadProtocol))
  result = call_579013.call(path_579014, query_579015, nil, nil, nil)

var loggingProjectsMetricsList* = Call_LoggingProjectsMetricsList_578995(
    name: "loggingProjectsMetricsList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2beta1/{parent}/metrics",
    validator: validate_LoggingProjectsMetricsList_578996, base: "/",
    url: url_LoggingProjectsMetricsList_578997, schemes: {Scheme.Https})
type
  Call_LoggingProjectsSinksCreate_579058 = ref object of OpenApiRestCall_578339
proc url_LoggingProjectsSinksCreate_579060(protocol: Scheme; host: string;
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

proc validate_LoggingProjectsSinksCreate_579059(path: JsonNode; query: JsonNode;
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
  var valid_579061 = path.getOrDefault("parent")
  valid_579061 = validateParameter(valid_579061, JString, required = true,
                                 default = nil)
  if valid_579061 != nil:
    section.add "parent", valid_579061
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
  var valid_579062 = query.getOrDefault("key")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "key", valid_579062
  var valid_579063 = query.getOrDefault("prettyPrint")
  valid_579063 = validateParameter(valid_579063, JBool, required = false,
                                 default = newJBool(true))
  if valid_579063 != nil:
    section.add "prettyPrint", valid_579063
  var valid_579064 = query.getOrDefault("oauth_token")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "oauth_token", valid_579064
  var valid_579065 = query.getOrDefault("$.xgafv")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = newJString("1"))
  if valid_579065 != nil:
    section.add "$.xgafv", valid_579065
  var valid_579066 = query.getOrDefault("alt")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = newJString("json"))
  if valid_579066 != nil:
    section.add "alt", valid_579066
  var valid_579067 = query.getOrDefault("uploadType")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "uploadType", valid_579067
  var valid_579068 = query.getOrDefault("quotaUser")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "quotaUser", valid_579068
  var valid_579069 = query.getOrDefault("uniqueWriterIdentity")
  valid_579069 = validateParameter(valid_579069, JBool, required = false, default = nil)
  if valid_579069 != nil:
    section.add "uniqueWriterIdentity", valid_579069
  var valid_579070 = query.getOrDefault("callback")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "callback", valid_579070
  var valid_579071 = query.getOrDefault("fields")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "fields", valid_579071
  var valid_579072 = query.getOrDefault("access_token")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "access_token", valid_579072
  var valid_579073 = query.getOrDefault("upload_protocol")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "upload_protocol", valid_579073
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

proc call*(call_579075: Call_LoggingProjectsSinksCreate_579058; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a sink that exports specified log entries to a destination. The export of newly-ingested log entries begins immediately, unless the sink's writer_identity is not permitted to write to the destination. A sink can export log entries only from the resource owning the sink.
  ## 
  let valid = call_579075.validator(path, query, header, formData, body)
  let scheme = call_579075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579075.url(scheme.get, call_579075.host, call_579075.base,
                         call_579075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579075, url, valid)

proc call*(call_579076: Call_LoggingProjectsSinksCreate_579058; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; uniqueWriterIdentity: bool = false;
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## loggingProjectsSinksCreate
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
  var path_579077 = newJObject()
  var query_579078 = newJObject()
  var body_579079 = newJObject()
  add(query_579078, "key", newJString(key))
  add(query_579078, "prettyPrint", newJBool(prettyPrint))
  add(query_579078, "oauth_token", newJString(oauthToken))
  add(query_579078, "$.xgafv", newJString(Xgafv))
  add(query_579078, "alt", newJString(alt))
  add(query_579078, "uploadType", newJString(uploadType))
  add(query_579078, "quotaUser", newJString(quotaUser))
  add(query_579078, "uniqueWriterIdentity", newJBool(uniqueWriterIdentity))
  if body != nil:
    body_579079 = body
  add(query_579078, "callback", newJString(callback))
  add(path_579077, "parent", newJString(parent))
  add(query_579078, "fields", newJString(fields))
  add(query_579078, "access_token", newJString(accessToken))
  add(query_579078, "upload_protocol", newJString(uploadProtocol))
  result = call_579076.call(path_579077, query_579078, nil, nil, body_579079)

var loggingProjectsSinksCreate* = Call_LoggingProjectsSinksCreate_579058(
    name: "loggingProjectsSinksCreate", meth: HttpMethod.HttpPost,
    host: "logging.googleapis.com", route: "/v2beta1/{parent}/sinks",
    validator: validate_LoggingProjectsSinksCreate_579059, base: "/",
    url: url_LoggingProjectsSinksCreate_579060, schemes: {Scheme.Https})
type
  Call_LoggingProjectsSinksList_579037 = ref object of OpenApiRestCall_578339
proc url_LoggingProjectsSinksList_579039(protocol: Scheme; host: string;
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

proc validate_LoggingProjectsSinksList_579038(path: JsonNode; query: JsonNode;
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
  var valid_579040 = path.getOrDefault("parent")
  valid_579040 = validateParameter(valid_579040, JString, required = true,
                                 default = nil)
  if valid_579040 != nil:
    section.add "parent", valid_579040
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
  var valid_579041 = query.getOrDefault("key")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "key", valid_579041
  var valid_579042 = query.getOrDefault("prettyPrint")
  valid_579042 = validateParameter(valid_579042, JBool, required = false,
                                 default = newJBool(true))
  if valid_579042 != nil:
    section.add "prettyPrint", valid_579042
  var valid_579043 = query.getOrDefault("oauth_token")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "oauth_token", valid_579043
  var valid_579044 = query.getOrDefault("$.xgafv")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = newJString("1"))
  if valid_579044 != nil:
    section.add "$.xgafv", valid_579044
  var valid_579045 = query.getOrDefault("pageSize")
  valid_579045 = validateParameter(valid_579045, JInt, required = false, default = nil)
  if valid_579045 != nil:
    section.add "pageSize", valid_579045
  var valid_579046 = query.getOrDefault("alt")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = newJString("json"))
  if valid_579046 != nil:
    section.add "alt", valid_579046
  var valid_579047 = query.getOrDefault("uploadType")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "uploadType", valid_579047
  var valid_579048 = query.getOrDefault("quotaUser")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "quotaUser", valid_579048
  var valid_579049 = query.getOrDefault("pageToken")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "pageToken", valid_579049
  var valid_579050 = query.getOrDefault("callback")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "callback", valid_579050
  var valid_579051 = query.getOrDefault("fields")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "fields", valid_579051
  var valid_579052 = query.getOrDefault("access_token")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "access_token", valid_579052
  var valid_579053 = query.getOrDefault("upload_protocol")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "upload_protocol", valid_579053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579054: Call_LoggingProjectsSinksList_579037; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists sinks.
  ## 
  let valid = call_579054.validator(path, query, header, formData, body)
  let scheme = call_579054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579054.url(scheme.get, call_579054.host, call_579054.base,
                         call_579054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579054, url, valid)

proc call*(call_579055: Call_LoggingProjectsSinksList_579037; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## loggingProjectsSinksList
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
  var path_579056 = newJObject()
  var query_579057 = newJObject()
  add(query_579057, "key", newJString(key))
  add(query_579057, "prettyPrint", newJBool(prettyPrint))
  add(query_579057, "oauth_token", newJString(oauthToken))
  add(query_579057, "$.xgafv", newJString(Xgafv))
  add(query_579057, "pageSize", newJInt(pageSize))
  add(query_579057, "alt", newJString(alt))
  add(query_579057, "uploadType", newJString(uploadType))
  add(query_579057, "quotaUser", newJString(quotaUser))
  add(query_579057, "pageToken", newJString(pageToken))
  add(query_579057, "callback", newJString(callback))
  add(path_579056, "parent", newJString(parent))
  add(query_579057, "fields", newJString(fields))
  add(query_579057, "access_token", newJString(accessToken))
  add(query_579057, "upload_protocol", newJString(uploadProtocol))
  result = call_579055.call(path_579056, query_579057, nil, nil, nil)

var loggingProjectsSinksList* = Call_LoggingProjectsSinksList_579037(
    name: "loggingProjectsSinksList", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2beta1/{parent}/sinks",
    validator: validate_LoggingProjectsSinksList_579038, base: "/",
    url: url_LoggingProjectsSinksList_579039, schemes: {Scheme.Https})
type
  Call_LoggingProjectsSinksUpdate_579099 = ref object of OpenApiRestCall_578339
proc url_LoggingProjectsSinksUpdate_579101(protocol: Scheme; host: string;
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

proc validate_LoggingProjectsSinksUpdate_579100(path: JsonNode; query: JsonNode;
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
  var valid_579102 = path.getOrDefault("sinkName")
  valid_579102 = validateParameter(valid_579102, JString, required = true,
                                 default = nil)
  if valid_579102 != nil:
    section.add "sinkName", valid_579102
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
  var valid_579103 = query.getOrDefault("key")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "key", valid_579103
  var valid_579104 = query.getOrDefault("prettyPrint")
  valid_579104 = validateParameter(valid_579104, JBool, required = false,
                                 default = newJBool(true))
  if valid_579104 != nil:
    section.add "prettyPrint", valid_579104
  var valid_579105 = query.getOrDefault("oauth_token")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "oauth_token", valid_579105
  var valid_579106 = query.getOrDefault("$.xgafv")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = newJString("1"))
  if valid_579106 != nil:
    section.add "$.xgafv", valid_579106
  var valid_579107 = query.getOrDefault("alt")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = newJString("json"))
  if valid_579107 != nil:
    section.add "alt", valid_579107
  var valid_579108 = query.getOrDefault("uploadType")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "uploadType", valid_579108
  var valid_579109 = query.getOrDefault("quotaUser")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "quotaUser", valid_579109
  var valid_579110 = query.getOrDefault("updateMask")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "updateMask", valid_579110
  var valid_579111 = query.getOrDefault("uniqueWriterIdentity")
  valid_579111 = validateParameter(valid_579111, JBool, required = false, default = nil)
  if valid_579111 != nil:
    section.add "uniqueWriterIdentity", valid_579111
  var valid_579112 = query.getOrDefault("callback")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "callback", valid_579112
  var valid_579113 = query.getOrDefault("fields")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "fields", valid_579113
  var valid_579114 = query.getOrDefault("access_token")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "access_token", valid_579114
  var valid_579115 = query.getOrDefault("upload_protocol")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "upload_protocol", valid_579115
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

proc call*(call_579117: Call_LoggingProjectsSinksUpdate_579099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a sink. This method replaces the following fields in the existing sink with values from the new sink: destination, and filter.The updated sink might also have a new writer_identity; see the unique_writer_identity field.
  ## 
  let valid = call_579117.validator(path, query, header, formData, body)
  let scheme = call_579117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579117.url(scheme.get, call_579117.host, call_579117.base,
                         call_579117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579117, url, valid)

proc call*(call_579118: Call_LoggingProjectsSinksUpdate_579099; sinkName: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; updateMask: string = "";
          uniqueWriterIdentity: bool = false; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## loggingProjectsSinksUpdate
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
  var path_579119 = newJObject()
  var query_579120 = newJObject()
  var body_579121 = newJObject()
  add(query_579120, "key", newJString(key))
  add(query_579120, "prettyPrint", newJBool(prettyPrint))
  add(query_579120, "oauth_token", newJString(oauthToken))
  add(query_579120, "$.xgafv", newJString(Xgafv))
  add(query_579120, "alt", newJString(alt))
  add(query_579120, "uploadType", newJString(uploadType))
  add(query_579120, "quotaUser", newJString(quotaUser))
  add(query_579120, "updateMask", newJString(updateMask))
  add(path_579119, "sinkName", newJString(sinkName))
  add(query_579120, "uniqueWriterIdentity", newJBool(uniqueWriterIdentity))
  if body != nil:
    body_579121 = body
  add(query_579120, "callback", newJString(callback))
  add(query_579120, "fields", newJString(fields))
  add(query_579120, "access_token", newJString(accessToken))
  add(query_579120, "upload_protocol", newJString(uploadProtocol))
  result = call_579118.call(path_579119, query_579120, nil, nil, body_579121)

var loggingProjectsSinksUpdate* = Call_LoggingProjectsSinksUpdate_579099(
    name: "loggingProjectsSinksUpdate", meth: HttpMethod.HttpPut,
    host: "logging.googleapis.com", route: "/v2beta1/{sinkName}",
    validator: validate_LoggingProjectsSinksUpdate_579100, base: "/",
    url: url_LoggingProjectsSinksUpdate_579101, schemes: {Scheme.Https})
type
  Call_LoggingProjectsSinksGet_579080 = ref object of OpenApiRestCall_578339
proc url_LoggingProjectsSinksGet_579082(protocol: Scheme; host: string; base: string;
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

proc validate_LoggingProjectsSinksGet_579081(path: JsonNode; query: JsonNode;
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
  var valid_579083 = path.getOrDefault("sinkName")
  valid_579083 = validateParameter(valid_579083, JString, required = true,
                                 default = nil)
  if valid_579083 != nil:
    section.add "sinkName", valid_579083
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
  var valid_579084 = query.getOrDefault("key")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "key", valid_579084
  var valid_579085 = query.getOrDefault("prettyPrint")
  valid_579085 = validateParameter(valid_579085, JBool, required = false,
                                 default = newJBool(true))
  if valid_579085 != nil:
    section.add "prettyPrint", valid_579085
  var valid_579086 = query.getOrDefault("oauth_token")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "oauth_token", valid_579086
  var valid_579087 = query.getOrDefault("$.xgafv")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = newJString("1"))
  if valid_579087 != nil:
    section.add "$.xgafv", valid_579087
  var valid_579088 = query.getOrDefault("alt")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = newJString("json"))
  if valid_579088 != nil:
    section.add "alt", valid_579088
  var valid_579089 = query.getOrDefault("uploadType")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "uploadType", valid_579089
  var valid_579090 = query.getOrDefault("quotaUser")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "quotaUser", valid_579090
  var valid_579091 = query.getOrDefault("callback")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "callback", valid_579091
  var valid_579092 = query.getOrDefault("fields")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "fields", valid_579092
  var valid_579093 = query.getOrDefault("access_token")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "access_token", valid_579093
  var valid_579094 = query.getOrDefault("upload_protocol")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "upload_protocol", valid_579094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579095: Call_LoggingProjectsSinksGet_579080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a sink.
  ## 
  let valid = call_579095.validator(path, query, header, formData, body)
  let scheme = call_579095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579095.url(scheme.get, call_579095.host, call_579095.base,
                         call_579095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579095, url, valid)

proc call*(call_579096: Call_LoggingProjectsSinksGet_579080; sinkName: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## loggingProjectsSinksGet
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
  var path_579097 = newJObject()
  var query_579098 = newJObject()
  add(query_579098, "key", newJString(key))
  add(query_579098, "prettyPrint", newJBool(prettyPrint))
  add(query_579098, "oauth_token", newJString(oauthToken))
  add(query_579098, "$.xgafv", newJString(Xgafv))
  add(query_579098, "alt", newJString(alt))
  add(query_579098, "uploadType", newJString(uploadType))
  add(query_579098, "quotaUser", newJString(quotaUser))
  add(path_579097, "sinkName", newJString(sinkName))
  add(query_579098, "callback", newJString(callback))
  add(query_579098, "fields", newJString(fields))
  add(query_579098, "access_token", newJString(accessToken))
  add(query_579098, "upload_protocol", newJString(uploadProtocol))
  result = call_579096.call(path_579097, query_579098, nil, nil, nil)

var loggingProjectsSinksGet* = Call_LoggingProjectsSinksGet_579080(
    name: "loggingProjectsSinksGet", meth: HttpMethod.HttpGet,
    host: "logging.googleapis.com", route: "/v2beta1/{sinkName}",
    validator: validate_LoggingProjectsSinksGet_579081, base: "/",
    url: url_LoggingProjectsSinksGet_579082, schemes: {Scheme.Https})
type
  Call_LoggingProjectsSinksDelete_579122 = ref object of OpenApiRestCall_578339
proc url_LoggingProjectsSinksDelete_579124(protocol: Scheme; host: string;
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

proc validate_LoggingProjectsSinksDelete_579123(path: JsonNode; query: JsonNode;
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
  var valid_579125 = path.getOrDefault("sinkName")
  valid_579125 = validateParameter(valid_579125, JString, required = true,
                                 default = nil)
  if valid_579125 != nil:
    section.add "sinkName", valid_579125
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
  var valid_579126 = query.getOrDefault("key")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "key", valid_579126
  var valid_579127 = query.getOrDefault("prettyPrint")
  valid_579127 = validateParameter(valid_579127, JBool, required = false,
                                 default = newJBool(true))
  if valid_579127 != nil:
    section.add "prettyPrint", valid_579127
  var valid_579128 = query.getOrDefault("oauth_token")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "oauth_token", valid_579128
  var valid_579129 = query.getOrDefault("$.xgafv")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = newJString("1"))
  if valid_579129 != nil:
    section.add "$.xgafv", valid_579129
  var valid_579130 = query.getOrDefault("alt")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = newJString("json"))
  if valid_579130 != nil:
    section.add "alt", valid_579130
  var valid_579131 = query.getOrDefault("uploadType")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "uploadType", valid_579131
  var valid_579132 = query.getOrDefault("quotaUser")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "quotaUser", valid_579132
  var valid_579133 = query.getOrDefault("callback")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "callback", valid_579133
  var valid_579134 = query.getOrDefault("fields")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "fields", valid_579134
  var valid_579135 = query.getOrDefault("access_token")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "access_token", valid_579135
  var valid_579136 = query.getOrDefault("upload_protocol")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "upload_protocol", valid_579136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579137: Call_LoggingProjectsSinksDelete_579122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a sink. If the sink has a unique writer_identity, then that service account is also deleted.
  ## 
  let valid = call_579137.validator(path, query, header, formData, body)
  let scheme = call_579137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579137.url(scheme.get, call_579137.host, call_579137.base,
                         call_579137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579137, url, valid)

proc call*(call_579138: Call_LoggingProjectsSinksDelete_579122; sinkName: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## loggingProjectsSinksDelete
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
  var path_579139 = newJObject()
  var query_579140 = newJObject()
  add(query_579140, "key", newJString(key))
  add(query_579140, "prettyPrint", newJBool(prettyPrint))
  add(query_579140, "oauth_token", newJString(oauthToken))
  add(query_579140, "$.xgafv", newJString(Xgafv))
  add(query_579140, "alt", newJString(alt))
  add(query_579140, "uploadType", newJString(uploadType))
  add(query_579140, "quotaUser", newJString(quotaUser))
  add(path_579139, "sinkName", newJString(sinkName))
  add(query_579140, "callback", newJString(callback))
  add(query_579140, "fields", newJString(fields))
  add(query_579140, "access_token", newJString(accessToken))
  add(query_579140, "upload_protocol", newJString(uploadProtocol))
  result = call_579138.call(path_579139, query_579140, nil, nil, nil)

var loggingProjectsSinksDelete* = Call_LoggingProjectsSinksDelete_579122(
    name: "loggingProjectsSinksDelete", meth: HttpMethod.HttpDelete,
    host: "logging.googleapis.com", route: "/v2beta1/{sinkName}",
    validator: validate_LoggingProjectsSinksDelete_579123, base: "/",
    url: url_LoggingProjectsSinksDelete_579124, schemes: {Scheme.Https})
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
