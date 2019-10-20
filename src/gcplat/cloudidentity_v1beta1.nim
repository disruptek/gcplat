
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Identity
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## API for provisioning and managing identity resources.
## 
## https://cloud.google.com/identity/
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
  gcpServiceName = "cloudidentity"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudidentityGroupsCreate_578610 = ref object of OpenApiRestCall_578339
proc url_CloudidentityGroupsCreate_578612(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsCreate_578611(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Group.
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

proc call*(call_578771: Call_CloudidentityGroupsCreate_578610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Group.
  ## 
  let valid = call_578771.validator(path, query, header, formData, body)
  let scheme = call_578771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578771.url(scheme.get, call_578771.host, call_578771.base,
                         call_578771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578771, url, valid)

proc call*(call_578842: Call_CloudidentityGroupsCreate_578610; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudidentityGroupsCreate
  ## Creates a Group.
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

var cloudidentityGroupsCreate* = Call_CloudidentityGroupsCreate_578610(
    name: "cloudidentityGroupsCreate", meth: HttpMethod.HttpPost,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/groups",
    validator: validate_CloudidentityGroupsCreate_578611, base: "/",
    url: url_CloudidentityGroupsCreate_578612, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsLookup_578884 = ref object of OpenApiRestCall_578339
proc url_CloudidentityGroupsLookup_578886(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsLookup_578885(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Group by
  ## its EntityKey.
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
  ##   groupKey.id: JString
  ##              : The id of the entity within the given namespace. The id must be unique
  ## within its namespace.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   groupKey.namespace: JString
  ##                     : Namespaces provide isolation for ids, i.e an id only needs to be unique
  ## within its namespace.
  ## 
  ## Namespaces are currently only created as part of IdentitySource creation
  ## from Admin Console. A namespace `"identitysources/{identity_source_id}"` is
  ## created corresponding to every Identity Source `identity_source_id`.
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
  var valid_578895 = query.getOrDefault("groupKey.id")
  valid_578895 = validateParameter(valid_578895, JString, required = false,
                                 default = nil)
  if valid_578895 != nil:
    section.add "groupKey.id", valid_578895
  var valid_578896 = query.getOrDefault("fields")
  valid_578896 = validateParameter(valid_578896, JString, required = false,
                                 default = nil)
  if valid_578896 != nil:
    section.add "fields", valid_578896
  var valid_578897 = query.getOrDefault("access_token")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "access_token", valid_578897
  var valid_578898 = query.getOrDefault("upload_protocol")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "upload_protocol", valid_578898
  var valid_578899 = query.getOrDefault("groupKey.namespace")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "groupKey.namespace", valid_578899
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578900: Call_CloudidentityGroupsLookup_578884; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Group by
  ## its EntityKey.
  ## 
  let valid = call_578900.validator(path, query, header, formData, body)
  let scheme = call_578900.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578900.url(scheme.get, call_578900.host, call_578900.base,
                         call_578900.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578900, url, valid)

proc call*(call_578901: Call_CloudidentityGroupsLookup_578884; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; groupKeyId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          groupKeyNamespace: string = ""): Recallable =
  ## cloudidentityGroupsLookup
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Group by
  ## its EntityKey.
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
  ##   groupKeyId: string
  ##             : The id of the entity within the given namespace. The id must be unique
  ## within its namespace.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   groupKeyNamespace: string
  ##                    : Namespaces provide isolation for ids, i.e an id only needs to be unique
  ## within its namespace.
  ## 
  ## Namespaces are currently only created as part of IdentitySource creation
  ## from Admin Console. A namespace `"identitysources/{identity_source_id}"` is
  ## created corresponding to every Identity Source `identity_source_id`.
  var query_578902 = newJObject()
  add(query_578902, "key", newJString(key))
  add(query_578902, "prettyPrint", newJBool(prettyPrint))
  add(query_578902, "oauth_token", newJString(oauthToken))
  add(query_578902, "$.xgafv", newJString(Xgafv))
  add(query_578902, "alt", newJString(alt))
  add(query_578902, "uploadType", newJString(uploadType))
  add(query_578902, "quotaUser", newJString(quotaUser))
  add(query_578902, "callback", newJString(callback))
  add(query_578902, "groupKey.id", newJString(groupKeyId))
  add(query_578902, "fields", newJString(fields))
  add(query_578902, "access_token", newJString(accessToken))
  add(query_578902, "upload_protocol", newJString(uploadProtocol))
  add(query_578902, "groupKey.namespace", newJString(groupKeyNamespace))
  result = call_578901.call(nil, query_578902, nil, nil, nil)

var cloudidentityGroupsLookup* = Call_CloudidentityGroupsLookup_578884(
    name: "cloudidentityGroupsLookup", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/groups:lookup",
    validator: validate_CloudidentityGroupsLookup_578885, base: "/",
    url: url_CloudidentityGroupsLookup_578886, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsSearch_578903 = ref object of OpenApiRestCall_578339
proc url_CloudidentityGroupsSearch_578905(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsSearch_578904(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Searches for Groups.
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
  ##           : The default page size is 200 (max 1000) for the BASIC view, and 50
  ## (max 500) for the FULL view.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous search request, if any.
  ##   query: JString
  ##        : Query string for performing search on groups.
  ## Users can search on namespace and label attributes of groups.
  ## EXACT match ('=') is supported on namespace, and CONTAINS match (':') is
  ## supported on labels. This is a `required` field.
  ## Multiple queries can be combined using `AND` operator. The operator is case
  ## sensitive.
  ## An example query would be:
  ## "namespace=<namespace_value> AND labels:<labels_value>".
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: JString
  ##       : Group resource view to be returned. Defaults to [GroupView.BASIC]().
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
  var valid_578915 = query.getOrDefault("query")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "query", valid_578915
  var valid_578916 = query.getOrDefault("callback")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "callback", valid_578916
  var valid_578917 = query.getOrDefault("fields")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "fields", valid_578917
  var valid_578918 = query.getOrDefault("access_token")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "access_token", valid_578918
  var valid_578919 = query.getOrDefault("upload_protocol")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "upload_protocol", valid_578919
  var valid_578920 = query.getOrDefault("view")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_578920 != nil:
    section.add "view", valid_578920
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578921: Call_CloudidentityGroupsSearch_578903; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for Groups.
  ## 
  let valid = call_578921.validator(path, query, header, formData, body)
  let scheme = call_578921.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578921.url(scheme.get, call_578921.host, call_578921.base,
                         call_578921.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578921, url, valid)

proc call*(call_578922: Call_CloudidentityGroupsSearch_578903; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; query: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; view: string = "BASIC"): Recallable =
  ## cloudidentityGroupsSearch
  ## Searches for Groups.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The default page size is 200 (max 1000) for the BASIC view, and 50
  ## (max 500) for the FULL view.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous search request, if any.
  ##   query: string
  ##        : Query string for performing search on groups.
  ## Users can search on namespace and label attributes of groups.
  ## EXACT match ('=') is supported on namespace, and CONTAINS match (':') is
  ## supported on labels. This is a `required` field.
  ## Multiple queries can be combined using `AND` operator. The operator is case
  ## sensitive.
  ## An example query would be:
  ## "namespace=<namespace_value> AND labels:<labels_value>".
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : Group resource view to be returned. Defaults to [GroupView.BASIC]().
  var query_578923 = newJObject()
  add(query_578923, "key", newJString(key))
  add(query_578923, "prettyPrint", newJBool(prettyPrint))
  add(query_578923, "oauth_token", newJString(oauthToken))
  add(query_578923, "$.xgafv", newJString(Xgafv))
  add(query_578923, "pageSize", newJInt(pageSize))
  add(query_578923, "alt", newJString(alt))
  add(query_578923, "uploadType", newJString(uploadType))
  add(query_578923, "quotaUser", newJString(quotaUser))
  add(query_578923, "pageToken", newJString(pageToken))
  add(query_578923, "query", newJString(query))
  add(query_578923, "callback", newJString(callback))
  add(query_578923, "fields", newJString(fields))
  add(query_578923, "access_token", newJString(accessToken))
  add(query_578923, "upload_protocol", newJString(uploadProtocol))
  add(query_578923, "view", newJString(view))
  result = call_578922.call(nil, query_578923, nil, nil, nil)

var cloudidentityGroupsSearch* = Call_CloudidentityGroupsSearch_578903(
    name: "cloudidentityGroupsSearch", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/groups:search",
    validator: validate_CloudidentityGroupsSearch_578904, base: "/",
    url: url_CloudidentityGroupsSearch_578905, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsGet_578924 = ref object of OpenApiRestCall_578339
proc url_CloudidentityGroupsMembershipsGet_578926(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsMembershipsGet_578925(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a Membership.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Membership to be retrieved.
  ## 
  ## Format: `groups/{group_id}/memberships/{member_id}`, where `group_id` is
  ## the unique id assigned to the Group to which Membership belongs to, and
  ## `member_id` is the unique id assigned to the member.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578941 = path.getOrDefault("name")
  valid_578941 = validateParameter(valid_578941, JString, required = true,
                                 default = nil)
  if valid_578941 != nil:
    section.add "name", valid_578941
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
  var valid_578942 = query.getOrDefault("key")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "key", valid_578942
  var valid_578943 = query.getOrDefault("prettyPrint")
  valid_578943 = validateParameter(valid_578943, JBool, required = false,
                                 default = newJBool(true))
  if valid_578943 != nil:
    section.add "prettyPrint", valid_578943
  var valid_578944 = query.getOrDefault("oauth_token")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "oauth_token", valid_578944
  var valid_578945 = query.getOrDefault("$.xgafv")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = newJString("1"))
  if valid_578945 != nil:
    section.add "$.xgafv", valid_578945
  var valid_578946 = query.getOrDefault("alt")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = newJString("json"))
  if valid_578946 != nil:
    section.add "alt", valid_578946
  var valid_578947 = query.getOrDefault("uploadType")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "uploadType", valid_578947
  var valid_578948 = query.getOrDefault("quotaUser")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "quotaUser", valid_578948
  var valid_578949 = query.getOrDefault("callback")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "callback", valid_578949
  var valid_578950 = query.getOrDefault("fields")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "fields", valid_578950
  var valid_578951 = query.getOrDefault("access_token")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "access_token", valid_578951
  var valid_578952 = query.getOrDefault("upload_protocol")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "upload_protocol", valid_578952
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578953: Call_CloudidentityGroupsMembershipsGet_578924;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a Membership.
  ## 
  let valid = call_578953.validator(path, query, header, formData, body)
  let scheme = call_578953.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578953.url(scheme.get, call_578953.host, call_578953.base,
                         call_578953.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578953, url, valid)

proc call*(call_578954: Call_CloudidentityGroupsMembershipsGet_578924;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudidentityGroupsMembershipsGet
  ## Retrieves a Membership.
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
  ##       : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Membership to be retrieved.
  ## 
  ## Format: `groups/{group_id}/memberships/{member_id}`, where `group_id` is
  ## the unique id assigned to the Group to which Membership belongs to, and
  ## `member_id` is the unique id assigned to the member.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578955 = newJObject()
  var query_578956 = newJObject()
  add(query_578956, "key", newJString(key))
  add(query_578956, "prettyPrint", newJBool(prettyPrint))
  add(query_578956, "oauth_token", newJString(oauthToken))
  add(query_578956, "$.xgafv", newJString(Xgafv))
  add(query_578956, "alt", newJString(alt))
  add(query_578956, "uploadType", newJString(uploadType))
  add(query_578956, "quotaUser", newJString(quotaUser))
  add(path_578955, "name", newJString(name))
  add(query_578956, "callback", newJString(callback))
  add(query_578956, "fields", newJString(fields))
  add(query_578956, "access_token", newJString(accessToken))
  add(query_578956, "upload_protocol", newJString(uploadProtocol))
  result = call_578954.call(path_578955, query_578956, nil, nil, nil)

var cloudidentityGroupsMembershipsGet* = Call_CloudidentityGroupsMembershipsGet_578924(
    name: "cloudidentityGroupsMembershipsGet", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudidentityGroupsMembershipsGet_578925, base: "/",
    url: url_CloudidentityGroupsMembershipsGet_578926, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsPatch_578976 = ref object of OpenApiRestCall_578339
proc url_CloudidentityGroupsPatch_578978(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsPatch_578977(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a Group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Group in the format: `groups/{group_id}`, where group_id is the unique id
  ## assigned to the Group.
  ## 
  ## Must be left blank while creating a Group
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578979 = path.getOrDefault("name")
  valid_578979 = validateParameter(valid_578979, JString, required = true,
                                 default = nil)
  if valid_578979 != nil:
    section.add "name", valid_578979
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
  ##             : Editable fields: `display_name`, `description`
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
  var valid_578987 = query.getOrDefault("updateMask")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "updateMask", valid_578987
  var valid_578988 = query.getOrDefault("callback")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "callback", valid_578988
  var valid_578989 = query.getOrDefault("fields")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "fields", valid_578989
  var valid_578990 = query.getOrDefault("access_token")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "access_token", valid_578990
  var valid_578991 = query.getOrDefault("upload_protocol")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "upload_protocol", valid_578991
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

proc call*(call_578993: Call_CloudidentityGroupsPatch_578976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Group.
  ## 
  let valid = call_578993.validator(path, query, header, formData, body)
  let scheme = call_578993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578993.url(scheme.get, call_578993.host, call_578993.base,
                         call_578993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578993, url, valid)

proc call*(call_578994: Call_CloudidentityGroupsPatch_578976; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; updateMask: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudidentityGroupsPatch
  ## Updates a Group.
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
  ##       : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Group in the format: `groups/{group_id}`, where group_id is the unique id
  ## assigned to the Group.
  ## 
  ## Must be left blank while creating a Group
  ##   updateMask: string
  ##             : Editable fields: `display_name`, `description`
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578995 = newJObject()
  var query_578996 = newJObject()
  var body_578997 = newJObject()
  add(query_578996, "key", newJString(key))
  add(query_578996, "prettyPrint", newJBool(prettyPrint))
  add(query_578996, "oauth_token", newJString(oauthToken))
  add(query_578996, "$.xgafv", newJString(Xgafv))
  add(query_578996, "alt", newJString(alt))
  add(query_578996, "uploadType", newJString(uploadType))
  add(query_578996, "quotaUser", newJString(quotaUser))
  add(path_578995, "name", newJString(name))
  add(query_578996, "updateMask", newJString(updateMask))
  if body != nil:
    body_578997 = body
  add(query_578996, "callback", newJString(callback))
  add(query_578996, "fields", newJString(fields))
  add(query_578996, "access_token", newJString(accessToken))
  add(query_578996, "upload_protocol", newJString(uploadProtocol))
  result = call_578994.call(path_578995, query_578996, nil, nil, body_578997)

var cloudidentityGroupsPatch* = Call_CloudidentityGroupsPatch_578976(
    name: "cloudidentityGroupsPatch", meth: HttpMethod.HttpPatch,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudidentityGroupsPatch_578977, base: "/",
    url: url_CloudidentityGroupsPatch_578978, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsDelete_578957 = ref object of OpenApiRestCall_578339
proc url_CloudidentityGroupsMembershipsDelete_578959(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsMembershipsDelete_578958(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a Membership.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Membership to be deleted.
  ## 
  ## Format: `groups/{group_id}/memberships/{member_id}`, where `group_id` is
  ## the unique id assigned to the Group to which Membership belongs to, and
  ## member_id is the unique id assigned to the member.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578960 = path.getOrDefault("name")
  valid_578960 = validateParameter(valid_578960, JString, required = true,
                                 default = nil)
  if valid_578960 != nil:
    section.add "name", valid_578960
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
  var valid_578961 = query.getOrDefault("key")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "key", valid_578961
  var valid_578962 = query.getOrDefault("prettyPrint")
  valid_578962 = validateParameter(valid_578962, JBool, required = false,
                                 default = newJBool(true))
  if valid_578962 != nil:
    section.add "prettyPrint", valid_578962
  var valid_578963 = query.getOrDefault("oauth_token")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "oauth_token", valid_578963
  var valid_578964 = query.getOrDefault("$.xgafv")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = newJString("1"))
  if valid_578964 != nil:
    section.add "$.xgafv", valid_578964
  var valid_578965 = query.getOrDefault("alt")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = newJString("json"))
  if valid_578965 != nil:
    section.add "alt", valid_578965
  var valid_578966 = query.getOrDefault("uploadType")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "uploadType", valid_578966
  var valid_578967 = query.getOrDefault("quotaUser")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "quotaUser", valid_578967
  var valid_578968 = query.getOrDefault("callback")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "callback", valid_578968
  var valid_578969 = query.getOrDefault("fields")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "fields", valid_578969
  var valid_578970 = query.getOrDefault("access_token")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "access_token", valid_578970
  var valid_578971 = query.getOrDefault("upload_protocol")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "upload_protocol", valid_578971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578972: Call_CloudidentityGroupsMembershipsDelete_578957;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a Membership.
  ## 
  let valid = call_578972.validator(path, query, header, formData, body)
  let scheme = call_578972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578972.url(scheme.get, call_578972.host, call_578972.base,
                         call_578972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578972, url, valid)

proc call*(call_578973: Call_CloudidentityGroupsMembershipsDelete_578957;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudidentityGroupsMembershipsDelete
  ## Deletes a Membership.
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
  ##       : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Membership to be deleted.
  ## 
  ## Format: `groups/{group_id}/memberships/{member_id}`, where `group_id` is
  ## the unique id assigned to the Group to which Membership belongs to, and
  ## member_id is the unique id assigned to the member.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578974 = newJObject()
  var query_578975 = newJObject()
  add(query_578975, "key", newJString(key))
  add(query_578975, "prettyPrint", newJBool(prettyPrint))
  add(query_578975, "oauth_token", newJString(oauthToken))
  add(query_578975, "$.xgafv", newJString(Xgafv))
  add(query_578975, "alt", newJString(alt))
  add(query_578975, "uploadType", newJString(uploadType))
  add(query_578975, "quotaUser", newJString(quotaUser))
  add(path_578974, "name", newJString(name))
  add(query_578975, "callback", newJString(callback))
  add(query_578975, "fields", newJString(fields))
  add(query_578975, "access_token", newJString(accessToken))
  add(query_578975, "upload_protocol", newJString(uploadProtocol))
  result = call_578973.call(path_578974, query_578975, nil, nil, nil)

var cloudidentityGroupsMembershipsDelete* = Call_CloudidentityGroupsMembershipsDelete_578957(
    name: "cloudidentityGroupsMembershipsDelete", meth: HttpMethod.HttpDelete,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudidentityGroupsMembershipsDelete_578958, base: "/",
    url: url_CloudidentityGroupsMembershipsDelete_578959, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsCreate_579020 = ref object of OpenApiRestCall_578339
proc url_CloudidentityGroupsMembershipsCreate_579022(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/memberships")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsMembershipsCreate_579021(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Membership.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Group to create Membership within. Format: `groups/{group_id}`, where
  ## `group_id` is the unique id assigned to the Group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579023 = path.getOrDefault("parent")
  valid_579023 = validateParameter(valid_579023, JString, required = true,
                                 default = nil)
  if valid_579023 != nil:
    section.add "parent", valid_579023
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
  var valid_579024 = query.getOrDefault("key")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "key", valid_579024
  var valid_579025 = query.getOrDefault("prettyPrint")
  valid_579025 = validateParameter(valid_579025, JBool, required = false,
                                 default = newJBool(true))
  if valid_579025 != nil:
    section.add "prettyPrint", valid_579025
  var valid_579026 = query.getOrDefault("oauth_token")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "oauth_token", valid_579026
  var valid_579027 = query.getOrDefault("$.xgafv")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = newJString("1"))
  if valid_579027 != nil:
    section.add "$.xgafv", valid_579027
  var valid_579028 = query.getOrDefault("alt")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = newJString("json"))
  if valid_579028 != nil:
    section.add "alt", valid_579028
  var valid_579029 = query.getOrDefault("uploadType")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "uploadType", valid_579029
  var valid_579030 = query.getOrDefault("quotaUser")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "quotaUser", valid_579030
  var valid_579031 = query.getOrDefault("callback")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "callback", valid_579031
  var valid_579032 = query.getOrDefault("fields")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "fields", valid_579032
  var valid_579033 = query.getOrDefault("access_token")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "access_token", valid_579033
  var valid_579034 = query.getOrDefault("upload_protocol")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "upload_protocol", valid_579034
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

proc call*(call_579036: Call_CloudidentityGroupsMembershipsCreate_579020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Membership.
  ## 
  let valid = call_579036.validator(path, query, header, formData, body)
  let scheme = call_579036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579036.url(scheme.get, call_579036.host, call_579036.base,
                         call_579036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579036, url, valid)

proc call*(call_579037: Call_CloudidentityGroupsMembershipsCreate_579020;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudidentityGroupsMembershipsCreate
  ## Creates a Membership.
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
  ##         : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Group to create Membership within. Format: `groups/{group_id}`, where
  ## `group_id` is the unique id assigned to the Group.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579038 = newJObject()
  var query_579039 = newJObject()
  var body_579040 = newJObject()
  add(query_579039, "key", newJString(key))
  add(query_579039, "prettyPrint", newJBool(prettyPrint))
  add(query_579039, "oauth_token", newJString(oauthToken))
  add(query_579039, "$.xgafv", newJString(Xgafv))
  add(query_579039, "alt", newJString(alt))
  add(query_579039, "uploadType", newJString(uploadType))
  add(query_579039, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579040 = body
  add(query_579039, "callback", newJString(callback))
  add(path_579038, "parent", newJString(parent))
  add(query_579039, "fields", newJString(fields))
  add(query_579039, "access_token", newJString(accessToken))
  add(query_579039, "upload_protocol", newJString(uploadProtocol))
  result = call_579037.call(path_579038, query_579039, nil, nil, body_579040)

var cloudidentityGroupsMembershipsCreate* = Call_CloudidentityGroupsMembershipsCreate_579020(
    name: "cloudidentityGroupsMembershipsCreate", meth: HttpMethod.HttpPost,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/{parent}/memberships",
    validator: validate_CloudidentityGroupsMembershipsCreate_579021, base: "/",
    url: url_CloudidentityGroupsMembershipsCreate_579022, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsList_578998 = ref object of OpenApiRestCall_578339
proc url_CloudidentityGroupsMembershipsList_579000(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/memberships")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsMembershipsList_578999(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Memberships within a Group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Group to list Memberships within.
  ## 
  ## Format: `groups/{group_id}`, where `group_id` is the unique id assigned to
  ## the Group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579001 = path.getOrDefault("parent")
  valid_579001 = validateParameter(valid_579001, JString, required = true,
                                 default = nil)
  if valid_579001 != nil:
    section.add "parent", valid_579001
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
  ##           : The default page size is 200 (max 1000) for the BASIC view, and 50
  ## (max 500) for the FULL view.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous list request, if any
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: JString
  ##       : Membership resource view to be returned. Defaults to MembershipView.BASIC.
  section = newJObject()
  var valid_579002 = query.getOrDefault("key")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "key", valid_579002
  var valid_579003 = query.getOrDefault("prettyPrint")
  valid_579003 = validateParameter(valid_579003, JBool, required = false,
                                 default = newJBool(true))
  if valid_579003 != nil:
    section.add "prettyPrint", valid_579003
  var valid_579004 = query.getOrDefault("oauth_token")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "oauth_token", valid_579004
  var valid_579005 = query.getOrDefault("$.xgafv")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = newJString("1"))
  if valid_579005 != nil:
    section.add "$.xgafv", valid_579005
  var valid_579006 = query.getOrDefault("pageSize")
  valid_579006 = validateParameter(valid_579006, JInt, required = false, default = nil)
  if valid_579006 != nil:
    section.add "pageSize", valid_579006
  var valid_579007 = query.getOrDefault("alt")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = newJString("json"))
  if valid_579007 != nil:
    section.add "alt", valid_579007
  var valid_579008 = query.getOrDefault("uploadType")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "uploadType", valid_579008
  var valid_579009 = query.getOrDefault("quotaUser")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "quotaUser", valid_579009
  var valid_579010 = query.getOrDefault("pageToken")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "pageToken", valid_579010
  var valid_579011 = query.getOrDefault("callback")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "callback", valid_579011
  var valid_579012 = query.getOrDefault("fields")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "fields", valid_579012
  var valid_579013 = query.getOrDefault("access_token")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "access_token", valid_579013
  var valid_579014 = query.getOrDefault("upload_protocol")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "upload_protocol", valid_579014
  var valid_579015 = query.getOrDefault("view")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_579015 != nil:
    section.add "view", valid_579015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579016: Call_CloudidentityGroupsMembershipsList_578998;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Memberships within a Group.
  ## 
  let valid = call_579016.validator(path, query, header, formData, body)
  let scheme = call_579016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579016.url(scheme.get, call_579016.host, call_579016.base,
                         call_579016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579016, url, valid)

proc call*(call_579017: Call_CloudidentityGroupsMembershipsList_578998;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; view: string = "BASIC"): Recallable =
  ## cloudidentityGroupsMembershipsList
  ## List Memberships within a Group.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The default page size is 200 (max 1000) for the BASIC view, and 50
  ## (max 500) for the FULL view.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous list request, if any
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Group to list Memberships within.
  ## 
  ## Format: `groups/{group_id}`, where `group_id` is the unique id assigned to
  ## the Group.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : Membership resource view to be returned. Defaults to MembershipView.BASIC.
  var path_579018 = newJObject()
  var query_579019 = newJObject()
  add(query_579019, "key", newJString(key))
  add(query_579019, "prettyPrint", newJBool(prettyPrint))
  add(query_579019, "oauth_token", newJString(oauthToken))
  add(query_579019, "$.xgafv", newJString(Xgafv))
  add(query_579019, "pageSize", newJInt(pageSize))
  add(query_579019, "alt", newJString(alt))
  add(query_579019, "uploadType", newJString(uploadType))
  add(query_579019, "quotaUser", newJString(quotaUser))
  add(query_579019, "pageToken", newJString(pageToken))
  add(query_579019, "callback", newJString(callback))
  add(path_579018, "parent", newJString(parent))
  add(query_579019, "fields", newJString(fields))
  add(query_579019, "access_token", newJString(accessToken))
  add(query_579019, "upload_protocol", newJString(uploadProtocol))
  add(query_579019, "view", newJString(view))
  result = call_579017.call(path_579018, query_579019, nil, nil, nil)

var cloudidentityGroupsMembershipsList* = Call_CloudidentityGroupsMembershipsList_578998(
    name: "cloudidentityGroupsMembershipsList", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/{parent}/memberships",
    validator: validate_CloudidentityGroupsMembershipsList_578999, base: "/",
    url: url_CloudidentityGroupsMembershipsList_579000, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsLookup_579041 = ref object of OpenApiRestCall_578339
proc url_CloudidentityGroupsMembershipsLookup_579043(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/memberships:lookup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsMembershipsLookup_579042(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Membership
  ## within a Group by member's EntityKey.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Group to lookup Membership within.
  ## 
  ## Format: `groups/{group_id}`, where `group_id` is the unique id assigned to
  ## the Group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579044 = path.getOrDefault("parent")
  valid_579044 = validateParameter(valid_579044, JString, required = true,
                                 default = nil)
  if valid_579044 != nil:
    section.add "parent", valid_579044
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   memberKey.namespace: JString
  ##                      : Namespaces provide isolation for ids, i.e an id only needs to be unique
  ## within its namespace.
  ## 
  ## Namespaces are currently only created as part of IdentitySource creation
  ## from Admin Console. A namespace `"identitysources/{identity_source_id}"` is
  ## created corresponding to every Identity Source `identity_source_id`.
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
  ##   memberKey.id: JString
  ##               : The id of the entity within the given namespace. The id must be unique
  ## within its namespace.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579045 = query.getOrDefault("key")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "key", valid_579045
  var valid_579046 = query.getOrDefault("memberKey.namespace")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "memberKey.namespace", valid_579046
  var valid_579047 = query.getOrDefault("prettyPrint")
  valid_579047 = validateParameter(valid_579047, JBool, required = false,
                                 default = newJBool(true))
  if valid_579047 != nil:
    section.add "prettyPrint", valid_579047
  var valid_579048 = query.getOrDefault("oauth_token")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "oauth_token", valid_579048
  var valid_579049 = query.getOrDefault("$.xgafv")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = newJString("1"))
  if valid_579049 != nil:
    section.add "$.xgafv", valid_579049
  var valid_579050 = query.getOrDefault("alt")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = newJString("json"))
  if valid_579050 != nil:
    section.add "alt", valid_579050
  var valid_579051 = query.getOrDefault("uploadType")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "uploadType", valid_579051
  var valid_579052 = query.getOrDefault("quotaUser")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "quotaUser", valid_579052
  var valid_579053 = query.getOrDefault("memberKey.id")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "memberKey.id", valid_579053
  var valid_579054 = query.getOrDefault("callback")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "callback", valid_579054
  var valid_579055 = query.getOrDefault("fields")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "fields", valid_579055
  var valid_579056 = query.getOrDefault("access_token")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "access_token", valid_579056
  var valid_579057 = query.getOrDefault("upload_protocol")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "upload_protocol", valid_579057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579058: Call_CloudidentityGroupsMembershipsLookup_579041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Membership
  ## within a Group by member's EntityKey.
  ## 
  let valid = call_579058.validator(path, query, header, formData, body)
  let scheme = call_579058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579058.url(scheme.get, call_579058.host, call_579058.base,
                         call_579058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579058, url, valid)

proc call*(call_579059: Call_CloudidentityGroupsMembershipsLookup_579041;
          parent: string; key: string = ""; memberKeyNamespace: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          memberKeyId: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudidentityGroupsMembershipsLookup
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Membership
  ## within a Group by member's EntityKey.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   memberKeyNamespace: string
  ##                     : Namespaces provide isolation for ids, i.e an id only needs to be unique
  ## within its namespace.
  ## 
  ## Namespaces are currently only created as part of IdentitySource creation
  ## from Admin Console. A namespace `"identitysources/{identity_source_id}"` is
  ## created corresponding to every Identity Source `identity_source_id`.
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
  ##   memberKeyId: string
  ##              : The id of the entity within the given namespace. The id must be unique
  ## within its namespace.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Group to lookup Membership within.
  ## 
  ## Format: `groups/{group_id}`, where `group_id` is the unique id assigned to
  ## the Group.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579060 = newJObject()
  var query_579061 = newJObject()
  add(query_579061, "key", newJString(key))
  add(query_579061, "memberKey.namespace", newJString(memberKeyNamespace))
  add(query_579061, "prettyPrint", newJBool(prettyPrint))
  add(query_579061, "oauth_token", newJString(oauthToken))
  add(query_579061, "$.xgafv", newJString(Xgafv))
  add(query_579061, "alt", newJString(alt))
  add(query_579061, "uploadType", newJString(uploadType))
  add(query_579061, "quotaUser", newJString(quotaUser))
  add(query_579061, "memberKey.id", newJString(memberKeyId))
  add(query_579061, "callback", newJString(callback))
  add(path_579060, "parent", newJString(parent))
  add(query_579061, "fields", newJString(fields))
  add(query_579061, "access_token", newJString(accessToken))
  add(query_579061, "upload_protocol", newJString(uploadProtocol))
  result = call_579059.call(path_579060, query_579061, nil, nil, nil)

var cloudidentityGroupsMembershipsLookup* = Call_CloudidentityGroupsMembershipsLookup_579041(
    name: "cloudidentityGroupsMembershipsLookup", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com",
    route: "/v1beta1/{parent}/memberships:lookup",
    validator: validate_CloudidentityGroupsMembershipsLookup_579042, base: "/",
    url: url_CloudidentityGroupsMembershipsLookup_579043, schemes: {Scheme.Https})
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
