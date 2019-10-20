
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: People
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Provides access to information about profiles and contacts.
## 
## https://developers.google.com/people/
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

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
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
  gcpServiceName = "people"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PeopleContactGroupsCreate_578894 = ref object of OpenApiRestCall_578348
proc url_PeopleContactGroupsCreate_578896(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PeopleContactGroupsCreate_578895(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new contact group owned by the authenticated user.
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
  var valid_578897 = query.getOrDefault("key")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "key", valid_578897
  var valid_578898 = query.getOrDefault("prettyPrint")
  valid_578898 = validateParameter(valid_578898, JBool, required = false,
                                 default = newJBool(true))
  if valid_578898 != nil:
    section.add "prettyPrint", valid_578898
  var valid_578899 = query.getOrDefault("oauth_token")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "oauth_token", valid_578899
  var valid_578900 = query.getOrDefault("$.xgafv")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = newJString("1"))
  if valid_578900 != nil:
    section.add "$.xgafv", valid_578900
  var valid_578901 = query.getOrDefault("alt")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = newJString("json"))
  if valid_578901 != nil:
    section.add "alt", valid_578901
  var valid_578902 = query.getOrDefault("uploadType")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "uploadType", valid_578902
  var valid_578903 = query.getOrDefault("quotaUser")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = nil)
  if valid_578903 != nil:
    section.add "quotaUser", valid_578903
  var valid_578904 = query.getOrDefault("callback")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "callback", valid_578904
  var valid_578905 = query.getOrDefault("fields")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "fields", valid_578905
  var valid_578906 = query.getOrDefault("access_token")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "access_token", valid_578906
  var valid_578907 = query.getOrDefault("upload_protocol")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "upload_protocol", valid_578907
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

proc call*(call_578909: Call_PeopleContactGroupsCreate_578894; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new contact group owned by the authenticated user.
  ## 
  let valid = call_578909.validator(path, query, header, formData, body)
  let scheme = call_578909.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578909.url(scheme.get, call_578909.host, call_578909.base,
                         call_578909.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578909, url, valid)

proc call*(call_578910: Call_PeopleContactGroupsCreate_578894; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## peopleContactGroupsCreate
  ## Create a new contact group owned by the authenticated user.
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
  var query_578911 = newJObject()
  var body_578912 = newJObject()
  add(query_578911, "key", newJString(key))
  add(query_578911, "prettyPrint", newJBool(prettyPrint))
  add(query_578911, "oauth_token", newJString(oauthToken))
  add(query_578911, "$.xgafv", newJString(Xgafv))
  add(query_578911, "alt", newJString(alt))
  add(query_578911, "uploadType", newJString(uploadType))
  add(query_578911, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578912 = body
  add(query_578911, "callback", newJString(callback))
  add(query_578911, "fields", newJString(fields))
  add(query_578911, "access_token", newJString(accessToken))
  add(query_578911, "upload_protocol", newJString(uploadProtocol))
  result = call_578910.call(nil, query_578911, nil, nil, body_578912)

var peopleContactGroupsCreate* = Call_PeopleContactGroupsCreate_578894(
    name: "peopleContactGroupsCreate", meth: HttpMethod.HttpPost,
    host: "people.googleapis.com", route: "/v1/contactGroups",
    validator: validate_PeopleContactGroupsCreate_578895, base: "/",
    url: url_PeopleContactGroupsCreate_578896, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsList_578619 = ref object of OpenApiRestCall_578348
proc url_PeopleContactGroupsList_578621(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PeopleContactGroupsList_578620(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all contact groups owned by the authenticated user. Members of the
  ## contact groups are not populated.
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
  ##           : The maximum number of resources to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous call to
  ## [ListContactGroups](/people/api/rest/v1/contactgroups/list).
  ## Requests the next page of resources.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   syncToken: JString
  ##            : A sync token, returned by a previous call to `contactgroups.list`.
  ## Only resources changed since the sync token was created will be returned.
  section = newJObject()
  var valid_578733 = query.getOrDefault("key")
  valid_578733 = validateParameter(valid_578733, JString, required = false,
                                 default = nil)
  if valid_578733 != nil:
    section.add "key", valid_578733
  var valid_578747 = query.getOrDefault("prettyPrint")
  valid_578747 = validateParameter(valid_578747, JBool, required = false,
                                 default = newJBool(true))
  if valid_578747 != nil:
    section.add "prettyPrint", valid_578747
  var valid_578748 = query.getOrDefault("oauth_token")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "oauth_token", valid_578748
  var valid_578749 = query.getOrDefault("$.xgafv")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = newJString("1"))
  if valid_578749 != nil:
    section.add "$.xgafv", valid_578749
  var valid_578750 = query.getOrDefault("pageSize")
  valid_578750 = validateParameter(valid_578750, JInt, required = false, default = nil)
  if valid_578750 != nil:
    section.add "pageSize", valid_578750
  var valid_578751 = query.getOrDefault("alt")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = newJString("json"))
  if valid_578751 != nil:
    section.add "alt", valid_578751
  var valid_578752 = query.getOrDefault("uploadType")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = nil)
  if valid_578752 != nil:
    section.add "uploadType", valid_578752
  var valid_578753 = query.getOrDefault("quotaUser")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "quotaUser", valid_578753
  var valid_578754 = query.getOrDefault("pageToken")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "pageToken", valid_578754
  var valid_578755 = query.getOrDefault("callback")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "callback", valid_578755
  var valid_578756 = query.getOrDefault("fields")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "fields", valid_578756
  var valid_578757 = query.getOrDefault("access_token")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "access_token", valid_578757
  var valid_578758 = query.getOrDefault("upload_protocol")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "upload_protocol", valid_578758
  var valid_578759 = query.getOrDefault("syncToken")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "syncToken", valid_578759
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578782: Call_PeopleContactGroupsList_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all contact groups owned by the authenticated user. Members of the
  ## contact groups are not populated.
  ## 
  let valid = call_578782.validator(path, query, header, formData, body)
  let scheme = call_578782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578782.url(scheme.get, call_578782.host, call_578782.base,
                         call_578782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578782, url, valid)

proc call*(call_578853: Call_PeopleContactGroupsList_578619; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          syncToken: string = ""): Recallable =
  ## peopleContactGroupsList
  ## List all contact groups owned by the authenticated user. Members of the
  ## contact groups are not populated.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of resources to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous call to
  ## [ListContactGroups](/people/api/rest/v1/contactgroups/list).
  ## Requests the next page of resources.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   syncToken: string
  ##            : A sync token, returned by a previous call to `contactgroups.list`.
  ## Only resources changed since the sync token was created will be returned.
  var query_578854 = newJObject()
  add(query_578854, "key", newJString(key))
  add(query_578854, "prettyPrint", newJBool(prettyPrint))
  add(query_578854, "oauth_token", newJString(oauthToken))
  add(query_578854, "$.xgafv", newJString(Xgafv))
  add(query_578854, "pageSize", newJInt(pageSize))
  add(query_578854, "alt", newJString(alt))
  add(query_578854, "uploadType", newJString(uploadType))
  add(query_578854, "quotaUser", newJString(quotaUser))
  add(query_578854, "pageToken", newJString(pageToken))
  add(query_578854, "callback", newJString(callback))
  add(query_578854, "fields", newJString(fields))
  add(query_578854, "access_token", newJString(accessToken))
  add(query_578854, "upload_protocol", newJString(uploadProtocol))
  add(query_578854, "syncToken", newJString(syncToken))
  result = call_578853.call(nil, query_578854, nil, nil, nil)

var peopleContactGroupsList* = Call_PeopleContactGroupsList_578619(
    name: "peopleContactGroupsList", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/contactGroups",
    validator: validate_PeopleContactGroupsList_578620, base: "/",
    url: url_PeopleContactGroupsList_578621, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsBatchGet_578913 = ref object of OpenApiRestCall_578348
proc url_PeopleContactGroupsBatchGet_578915(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PeopleContactGroupsBatchGet_578914(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a list of contact groups owned by the authenticated user by specifying
  ## a list of contact group resource names.
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
  ##   resourceNames: JArray
  ##                : The resource names of the contact groups to get.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   maxMembers: JInt
  ##             : Specifies the maximum number of members to return for each group.
  section = newJObject()
  var valid_578916 = query.getOrDefault("key")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "key", valid_578916
  var valid_578917 = query.getOrDefault("prettyPrint")
  valid_578917 = validateParameter(valid_578917, JBool, required = false,
                                 default = newJBool(true))
  if valid_578917 != nil:
    section.add "prettyPrint", valid_578917
  var valid_578918 = query.getOrDefault("oauth_token")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "oauth_token", valid_578918
  var valid_578919 = query.getOrDefault("$.xgafv")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = newJString("1"))
  if valid_578919 != nil:
    section.add "$.xgafv", valid_578919
  var valid_578920 = query.getOrDefault("alt")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = newJString("json"))
  if valid_578920 != nil:
    section.add "alt", valid_578920
  var valid_578921 = query.getOrDefault("uploadType")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "uploadType", valid_578921
  var valid_578922 = query.getOrDefault("quotaUser")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "quotaUser", valid_578922
  var valid_578923 = query.getOrDefault("resourceNames")
  valid_578923 = validateParameter(valid_578923, JArray, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "resourceNames", valid_578923
  var valid_578924 = query.getOrDefault("callback")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "callback", valid_578924
  var valid_578925 = query.getOrDefault("fields")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "fields", valid_578925
  var valid_578926 = query.getOrDefault("access_token")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "access_token", valid_578926
  var valid_578927 = query.getOrDefault("upload_protocol")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "upload_protocol", valid_578927
  var valid_578928 = query.getOrDefault("maxMembers")
  valid_578928 = validateParameter(valid_578928, JInt, required = false, default = nil)
  if valid_578928 != nil:
    section.add "maxMembers", valid_578928
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578929: Call_PeopleContactGroupsBatchGet_578913; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of contact groups owned by the authenticated user by specifying
  ## a list of contact group resource names.
  ## 
  let valid = call_578929.validator(path, query, header, formData, body)
  let scheme = call_578929.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578929.url(scheme.get, call_578929.host, call_578929.base,
                         call_578929.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578929, url, valid)

proc call*(call_578930: Call_PeopleContactGroupsBatchGet_578913; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          resourceNames: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; maxMembers: int = 0): Recallable =
  ## peopleContactGroupsBatchGet
  ## Get a list of contact groups owned by the authenticated user by specifying
  ## a list of contact group resource names.
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
  ##   resourceNames: JArray
  ##                : The resource names of the contact groups to get.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   maxMembers: int
  ##             : Specifies the maximum number of members to return for each group.
  var query_578931 = newJObject()
  add(query_578931, "key", newJString(key))
  add(query_578931, "prettyPrint", newJBool(prettyPrint))
  add(query_578931, "oauth_token", newJString(oauthToken))
  add(query_578931, "$.xgafv", newJString(Xgafv))
  add(query_578931, "alt", newJString(alt))
  add(query_578931, "uploadType", newJString(uploadType))
  add(query_578931, "quotaUser", newJString(quotaUser))
  if resourceNames != nil:
    query_578931.add "resourceNames", resourceNames
  add(query_578931, "callback", newJString(callback))
  add(query_578931, "fields", newJString(fields))
  add(query_578931, "access_token", newJString(accessToken))
  add(query_578931, "upload_protocol", newJString(uploadProtocol))
  add(query_578931, "maxMembers", newJInt(maxMembers))
  result = call_578930.call(nil, query_578931, nil, nil, nil)

var peopleContactGroupsBatchGet* = Call_PeopleContactGroupsBatchGet_578913(
    name: "peopleContactGroupsBatchGet", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/contactGroups:batchGet",
    validator: validate_PeopleContactGroupsBatchGet_578914, base: "/",
    url: url_PeopleContactGroupsBatchGet_578915, schemes: {Scheme.Https})
type
  Call_PeoplePeopleGetBatchGet_578932 = ref object of OpenApiRestCall_578348
proc url_PeoplePeopleGetBatchGet_578934(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PeoplePeopleGetBatchGet_578933(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides information about a list of specific people by specifying a list
  ## of requested resource names. Use `people/me` to indicate the authenticated
  ## user.
  ## <br>
  ## The request throws a 400 error if 'personFields' is not specified.
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
  ##   resourceNames: JArray
  ##                : The resource names of the people to provide information about.
  ## 
  ## - To get information about the authenticated user, specify `people/me`.
  ## - To get information about a google account, specify
  ##   `people/`<var>account_id</var>.
  ## - To get information about a contact, specify the resource name that
  ##   identifies the contact as returned by
  ## [`people.connections.list`](/people/api/rest/v1/people.connections/list).
  ## 
  ## You can include up to 50 resource names in one request.
  ##   callback: JString
  ##           : JSONP
  ##   requestMask.includeField: JString
  ##                           : **Required.** Comma-separated list of person fields to be included in the
  ## response. Each path should start with `person.`: for example,
  ## `person.names` or `person.photos`.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   personFields: JString
  ##               : **Required.** A field mask to restrict which fields on each person are
  ## returned. Multiple fields can be specified by separating them with commas.
  ## Valid values are:
  ## 
  ## * addresses
  ## * ageRanges
  ## * biographies
  ## * birthdays
  ## * braggingRights
  ## * coverPhotos
  ## * emailAddresses
  ## * events
  ## * genders
  ## * imClients
  ## * interests
  ## * locales
  ## * memberships
  ## * metadata
  ## * names
  ## * nicknames
  ## * occupations
  ## * organizations
  ## * phoneNumbers
  ## * photos
  ## * relations
  ## * relationshipInterests
  ## * relationshipStatuses
  ## * residences
  ## * sipAddresses
  ## * skills
  ## * taglines
  ## * urls
  ## * userDefined
  section = newJObject()
  var valid_578935 = query.getOrDefault("key")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "key", valid_578935
  var valid_578936 = query.getOrDefault("prettyPrint")
  valid_578936 = validateParameter(valid_578936, JBool, required = false,
                                 default = newJBool(true))
  if valid_578936 != nil:
    section.add "prettyPrint", valid_578936
  var valid_578937 = query.getOrDefault("oauth_token")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "oauth_token", valid_578937
  var valid_578938 = query.getOrDefault("$.xgafv")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = newJString("1"))
  if valid_578938 != nil:
    section.add "$.xgafv", valid_578938
  var valid_578939 = query.getOrDefault("alt")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = newJString("json"))
  if valid_578939 != nil:
    section.add "alt", valid_578939
  var valid_578940 = query.getOrDefault("uploadType")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "uploadType", valid_578940
  var valid_578941 = query.getOrDefault("quotaUser")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "quotaUser", valid_578941
  var valid_578942 = query.getOrDefault("resourceNames")
  valid_578942 = validateParameter(valid_578942, JArray, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "resourceNames", valid_578942
  var valid_578943 = query.getOrDefault("callback")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "callback", valid_578943
  var valid_578944 = query.getOrDefault("requestMask.includeField")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "requestMask.includeField", valid_578944
  var valid_578945 = query.getOrDefault("fields")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "fields", valid_578945
  var valid_578946 = query.getOrDefault("access_token")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "access_token", valid_578946
  var valid_578947 = query.getOrDefault("upload_protocol")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "upload_protocol", valid_578947
  var valid_578948 = query.getOrDefault("personFields")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "personFields", valid_578948
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578949: Call_PeoplePeopleGetBatchGet_578932; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides information about a list of specific people by specifying a list
  ## of requested resource names. Use `people/me` to indicate the authenticated
  ## user.
  ## <br>
  ## The request throws a 400 error if 'personFields' is not specified.
  ## 
  let valid = call_578949.validator(path, query, header, formData, body)
  let scheme = call_578949.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578949.url(scheme.get, call_578949.host, call_578949.base,
                         call_578949.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578949, url, valid)

proc call*(call_578950: Call_PeoplePeopleGetBatchGet_578932; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          resourceNames: JsonNode = nil; callback: string = "";
          requestMaskIncludeField: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          personFields: string = ""): Recallable =
  ## peoplePeopleGetBatchGet
  ## Provides information about a list of specific people by specifying a list
  ## of requested resource names. Use `people/me` to indicate the authenticated
  ## user.
  ## <br>
  ## The request throws a 400 error if 'personFields' is not specified.
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
  ##   resourceNames: JArray
  ##                : The resource names of the people to provide information about.
  ## 
  ## - To get information about the authenticated user, specify `people/me`.
  ## - To get information about a google account, specify
  ##   `people/`<var>account_id</var>.
  ## - To get information about a contact, specify the resource name that
  ##   identifies the contact as returned by
  ## [`people.connections.list`](/people/api/rest/v1/people.connections/list).
  ## 
  ## You can include up to 50 resource names in one request.
  ##   callback: string
  ##           : JSONP
  ##   requestMaskIncludeField: string
  ##                          : **Required.** Comma-separated list of person fields to be included in the
  ## response. Each path should start with `person.`: for example,
  ## `person.names` or `person.photos`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   personFields: string
  ##               : **Required.** A field mask to restrict which fields on each person are
  ## returned. Multiple fields can be specified by separating them with commas.
  ## Valid values are:
  ## 
  ## * addresses
  ## * ageRanges
  ## * biographies
  ## * birthdays
  ## * braggingRights
  ## * coverPhotos
  ## * emailAddresses
  ## * events
  ## * genders
  ## * imClients
  ## * interests
  ## * locales
  ## * memberships
  ## * metadata
  ## * names
  ## * nicknames
  ## * occupations
  ## * organizations
  ## * phoneNumbers
  ## * photos
  ## * relations
  ## * relationshipInterests
  ## * relationshipStatuses
  ## * residences
  ## * sipAddresses
  ## * skills
  ## * taglines
  ## * urls
  ## * userDefined
  var query_578951 = newJObject()
  add(query_578951, "key", newJString(key))
  add(query_578951, "prettyPrint", newJBool(prettyPrint))
  add(query_578951, "oauth_token", newJString(oauthToken))
  add(query_578951, "$.xgafv", newJString(Xgafv))
  add(query_578951, "alt", newJString(alt))
  add(query_578951, "uploadType", newJString(uploadType))
  add(query_578951, "quotaUser", newJString(quotaUser))
  if resourceNames != nil:
    query_578951.add "resourceNames", resourceNames
  add(query_578951, "callback", newJString(callback))
  add(query_578951, "requestMask.includeField",
      newJString(requestMaskIncludeField))
  add(query_578951, "fields", newJString(fields))
  add(query_578951, "access_token", newJString(accessToken))
  add(query_578951, "upload_protocol", newJString(uploadProtocol))
  add(query_578951, "personFields", newJString(personFields))
  result = call_578950.call(nil, query_578951, nil, nil, nil)

var peoplePeopleGetBatchGet* = Call_PeoplePeopleGetBatchGet_578932(
    name: "peoplePeopleGetBatchGet", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/people:batchGet",
    validator: validate_PeoplePeopleGetBatchGet_578933, base: "/",
    url: url_PeoplePeopleGetBatchGet_578934, schemes: {Scheme.Https})
type
  Call_PeoplePeopleCreateContact_578952 = ref object of OpenApiRestCall_578348
proc url_PeoplePeopleCreateContact_578954(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PeoplePeopleCreateContact_578953(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new contact and return the person resource for that contact.
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
  ##   parent: JString
  ##         : The resource name of the owning person resource.
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
  var valid_578955 = query.getOrDefault("key")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "key", valid_578955
  var valid_578956 = query.getOrDefault("prettyPrint")
  valid_578956 = validateParameter(valid_578956, JBool, required = false,
                                 default = newJBool(true))
  if valid_578956 != nil:
    section.add "prettyPrint", valid_578956
  var valid_578957 = query.getOrDefault("oauth_token")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "oauth_token", valid_578957
  var valid_578958 = query.getOrDefault("$.xgafv")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = newJString("1"))
  if valid_578958 != nil:
    section.add "$.xgafv", valid_578958
  var valid_578959 = query.getOrDefault("alt")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = newJString("json"))
  if valid_578959 != nil:
    section.add "alt", valid_578959
  var valid_578960 = query.getOrDefault("uploadType")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "uploadType", valid_578960
  var valid_578961 = query.getOrDefault("parent")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "parent", valid_578961
  var valid_578962 = query.getOrDefault("quotaUser")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "quotaUser", valid_578962
  var valid_578963 = query.getOrDefault("callback")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "callback", valid_578963
  var valid_578964 = query.getOrDefault("fields")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "fields", valid_578964
  var valid_578965 = query.getOrDefault("access_token")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "access_token", valid_578965
  var valid_578966 = query.getOrDefault("upload_protocol")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "upload_protocol", valid_578966
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

proc call*(call_578968: Call_PeoplePeopleCreateContact_578952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new contact and return the person resource for that contact.
  ## 
  let valid = call_578968.validator(path, query, header, formData, body)
  let scheme = call_578968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578968.url(scheme.get, call_578968.host, call_578968.base,
                         call_578968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578968, url, valid)

proc call*(call_578969: Call_PeoplePeopleCreateContact_578952; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; parent: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## peoplePeopleCreateContact
  ## Create a new contact and return the person resource for that contact.
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
  ##   parent: string
  ##         : The resource name of the owning person resource.
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
  var query_578970 = newJObject()
  var body_578971 = newJObject()
  add(query_578970, "key", newJString(key))
  add(query_578970, "prettyPrint", newJBool(prettyPrint))
  add(query_578970, "oauth_token", newJString(oauthToken))
  add(query_578970, "$.xgafv", newJString(Xgafv))
  add(query_578970, "alt", newJString(alt))
  add(query_578970, "uploadType", newJString(uploadType))
  add(query_578970, "parent", newJString(parent))
  add(query_578970, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578971 = body
  add(query_578970, "callback", newJString(callback))
  add(query_578970, "fields", newJString(fields))
  add(query_578970, "access_token", newJString(accessToken))
  add(query_578970, "upload_protocol", newJString(uploadProtocol))
  result = call_578969.call(nil, query_578970, nil, nil, body_578971)

var peoplePeopleCreateContact* = Call_PeoplePeopleCreateContact_578952(
    name: "peoplePeopleCreateContact", meth: HttpMethod.HttpPost,
    host: "people.googleapis.com", route: "/v1/people:createContact",
    validator: validate_PeoplePeopleCreateContact_578953, base: "/",
    url: url_PeoplePeopleCreateContact_578954, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsUpdate_579007 = ref object of OpenApiRestCall_578348
proc url_PeopleContactGroupsUpdate_579009(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeopleContactGroupsUpdate_579008(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the name of an existing contact group owned by the authenticated
  ## user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : The resource name for the contact group, assigned by the server. An ASCII
  ## string, in the form of `contactGroups/`<var>contact_group_id</var>.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_579010 = path.getOrDefault("resourceName")
  valid_579010 = validateParameter(valid_579010, JString, required = true,
                                 default = nil)
  if valid_579010 != nil:
    section.add "resourceName", valid_579010
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
  var valid_579011 = query.getOrDefault("key")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "key", valid_579011
  var valid_579012 = query.getOrDefault("prettyPrint")
  valid_579012 = validateParameter(valid_579012, JBool, required = false,
                                 default = newJBool(true))
  if valid_579012 != nil:
    section.add "prettyPrint", valid_579012
  var valid_579013 = query.getOrDefault("oauth_token")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "oauth_token", valid_579013
  var valid_579014 = query.getOrDefault("$.xgafv")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = newJString("1"))
  if valid_579014 != nil:
    section.add "$.xgafv", valid_579014
  var valid_579015 = query.getOrDefault("alt")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = newJString("json"))
  if valid_579015 != nil:
    section.add "alt", valid_579015
  var valid_579016 = query.getOrDefault("uploadType")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "uploadType", valid_579016
  var valid_579017 = query.getOrDefault("quotaUser")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "quotaUser", valid_579017
  var valid_579018 = query.getOrDefault("callback")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "callback", valid_579018
  var valid_579019 = query.getOrDefault("fields")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "fields", valid_579019
  var valid_579020 = query.getOrDefault("access_token")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "access_token", valid_579020
  var valid_579021 = query.getOrDefault("upload_protocol")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "upload_protocol", valid_579021
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

proc call*(call_579023: Call_PeopleContactGroupsUpdate_579007; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the name of an existing contact group owned by the authenticated
  ## user.
  ## 
  let valid = call_579023.validator(path, query, header, formData, body)
  let scheme = call_579023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579023.url(scheme.get, call_579023.host, call_579023.base,
                         call_579023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579023, url, valid)

proc call*(call_579024: Call_PeopleContactGroupsUpdate_579007;
          resourceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## peopleContactGroupsUpdate
  ## Update the name of an existing contact group owned by the authenticated
  ## user.
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
  ##   resourceName: string (required)
  ##               : The resource name for the contact group, assigned by the server. An ASCII
  ## string, in the form of `contactGroups/`<var>contact_group_id</var>.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579025 = newJObject()
  var query_579026 = newJObject()
  var body_579027 = newJObject()
  add(query_579026, "key", newJString(key))
  add(query_579026, "prettyPrint", newJBool(prettyPrint))
  add(query_579026, "oauth_token", newJString(oauthToken))
  add(query_579026, "$.xgafv", newJString(Xgafv))
  add(query_579026, "alt", newJString(alt))
  add(query_579026, "uploadType", newJString(uploadType))
  add(query_579026, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579027 = body
  add(query_579026, "callback", newJString(callback))
  add(path_579025, "resourceName", newJString(resourceName))
  add(query_579026, "fields", newJString(fields))
  add(query_579026, "access_token", newJString(accessToken))
  add(query_579026, "upload_protocol", newJString(uploadProtocol))
  result = call_579024.call(path_579025, query_579026, nil, nil, body_579027)

var peopleContactGroupsUpdate* = Call_PeopleContactGroupsUpdate_579007(
    name: "peopleContactGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "people.googleapis.com", route: "/v1/{resourceName}",
    validator: validate_PeopleContactGroupsUpdate_579008, base: "/",
    url: url_PeopleContactGroupsUpdate_579009, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsGet_578972 = ref object of OpenApiRestCall_578348
proc url_PeopleContactGroupsGet_578974(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeopleContactGroupsGet_578973(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a specific contact group owned by the authenticated user by specifying
  ## a contact group resource name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : The resource name of the contact group to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_578989 = path.getOrDefault("resourceName")
  valid_578989 = validateParameter(valid_578989, JString, required = true,
                                 default = nil)
  if valid_578989 != nil:
    section.add "resourceName", valid_578989
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
  ##   requestMask.includeField: JString
  ##                           : **Required.** Comma-separated list of person fields to be included in the
  ## response. Each path should start with `person.`: for example,
  ## `person.names` or `person.photos`.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   maxMembers: JInt
  ##             : Specifies the maximum number of members to return.
  section = newJObject()
  var valid_578990 = query.getOrDefault("key")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "key", valid_578990
  var valid_578991 = query.getOrDefault("prettyPrint")
  valid_578991 = validateParameter(valid_578991, JBool, required = false,
                                 default = newJBool(true))
  if valid_578991 != nil:
    section.add "prettyPrint", valid_578991
  var valid_578992 = query.getOrDefault("oauth_token")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "oauth_token", valid_578992
  var valid_578993 = query.getOrDefault("$.xgafv")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = newJString("1"))
  if valid_578993 != nil:
    section.add "$.xgafv", valid_578993
  var valid_578994 = query.getOrDefault("alt")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = newJString("json"))
  if valid_578994 != nil:
    section.add "alt", valid_578994
  var valid_578995 = query.getOrDefault("uploadType")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "uploadType", valid_578995
  var valid_578996 = query.getOrDefault("quotaUser")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "quotaUser", valid_578996
  var valid_578997 = query.getOrDefault("callback")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "callback", valid_578997
  var valid_578998 = query.getOrDefault("requestMask.includeField")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "requestMask.includeField", valid_578998
  var valid_578999 = query.getOrDefault("fields")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "fields", valid_578999
  var valid_579000 = query.getOrDefault("access_token")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "access_token", valid_579000
  var valid_579001 = query.getOrDefault("upload_protocol")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "upload_protocol", valid_579001
  var valid_579002 = query.getOrDefault("maxMembers")
  valid_579002 = validateParameter(valid_579002, JInt, required = false, default = nil)
  if valid_579002 != nil:
    section.add "maxMembers", valid_579002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579003: Call_PeopleContactGroupsGet_578972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific contact group owned by the authenticated user by specifying
  ## a contact group resource name.
  ## 
  let valid = call_579003.validator(path, query, header, formData, body)
  let scheme = call_579003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579003.url(scheme.get, call_579003.host, call_579003.base,
                         call_579003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579003, url, valid)

proc call*(call_579004: Call_PeopleContactGroupsGet_578972; resourceName: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = "";
          requestMaskIncludeField: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; maxMembers: int = 0): Recallable =
  ## peopleContactGroupsGet
  ## Get a specific contact group owned by the authenticated user by specifying
  ## a contact group resource name.
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
  ##   resourceName: string (required)
  ##               : The resource name of the contact group to get.
  ##   requestMaskIncludeField: string
  ##                          : **Required.** Comma-separated list of person fields to be included in the
  ## response. Each path should start with `person.`: for example,
  ## `person.names` or `person.photos`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   maxMembers: int
  ##             : Specifies the maximum number of members to return.
  var path_579005 = newJObject()
  var query_579006 = newJObject()
  add(query_579006, "key", newJString(key))
  add(query_579006, "prettyPrint", newJBool(prettyPrint))
  add(query_579006, "oauth_token", newJString(oauthToken))
  add(query_579006, "$.xgafv", newJString(Xgafv))
  add(query_579006, "alt", newJString(alt))
  add(query_579006, "uploadType", newJString(uploadType))
  add(query_579006, "quotaUser", newJString(quotaUser))
  add(query_579006, "callback", newJString(callback))
  add(path_579005, "resourceName", newJString(resourceName))
  add(query_579006, "requestMask.includeField",
      newJString(requestMaskIncludeField))
  add(query_579006, "fields", newJString(fields))
  add(query_579006, "access_token", newJString(accessToken))
  add(query_579006, "upload_protocol", newJString(uploadProtocol))
  add(query_579006, "maxMembers", newJInt(maxMembers))
  result = call_579004.call(path_579005, query_579006, nil, nil, nil)

var peopleContactGroupsGet* = Call_PeopleContactGroupsGet_578972(
    name: "peopleContactGroupsGet", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/{resourceName}",
    validator: validate_PeopleContactGroupsGet_578973, base: "/",
    url: url_PeopleContactGroupsGet_578974, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsDelete_579028 = ref object of OpenApiRestCall_578348
proc url_PeopleContactGroupsDelete_579030(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeopleContactGroupsDelete_579029(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an existing contact group owned by the authenticated user by
  ## specifying a contact group resource name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : The resource name of the contact group to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_579031 = path.getOrDefault("resourceName")
  valid_579031 = validateParameter(valid_579031, JString, required = true,
                                 default = nil)
  if valid_579031 != nil:
    section.add "resourceName", valid_579031
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
  ##   deleteContacts: JBool
  ##                 : Set to true to also delete the contacts in the specified group.
  section = newJObject()
  var valid_579032 = query.getOrDefault("key")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "key", valid_579032
  var valid_579033 = query.getOrDefault("prettyPrint")
  valid_579033 = validateParameter(valid_579033, JBool, required = false,
                                 default = newJBool(true))
  if valid_579033 != nil:
    section.add "prettyPrint", valid_579033
  var valid_579034 = query.getOrDefault("oauth_token")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "oauth_token", valid_579034
  var valid_579035 = query.getOrDefault("$.xgafv")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = newJString("1"))
  if valid_579035 != nil:
    section.add "$.xgafv", valid_579035
  var valid_579036 = query.getOrDefault("alt")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = newJString("json"))
  if valid_579036 != nil:
    section.add "alt", valid_579036
  var valid_579037 = query.getOrDefault("uploadType")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "uploadType", valid_579037
  var valid_579038 = query.getOrDefault("quotaUser")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "quotaUser", valid_579038
  var valid_579039 = query.getOrDefault("callback")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "callback", valid_579039
  var valid_579040 = query.getOrDefault("fields")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "fields", valid_579040
  var valid_579041 = query.getOrDefault("access_token")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "access_token", valid_579041
  var valid_579042 = query.getOrDefault("upload_protocol")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "upload_protocol", valid_579042
  var valid_579043 = query.getOrDefault("deleteContacts")
  valid_579043 = validateParameter(valid_579043, JBool, required = false, default = nil)
  if valid_579043 != nil:
    section.add "deleteContacts", valid_579043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579044: Call_PeopleContactGroupsDelete_579028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing contact group owned by the authenticated user by
  ## specifying a contact group resource name.
  ## 
  let valid = call_579044.validator(path, query, header, formData, body)
  let scheme = call_579044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579044.url(scheme.get, call_579044.host, call_579044.base,
                         call_579044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579044, url, valid)

proc call*(call_579045: Call_PeopleContactGroupsDelete_579028;
          resourceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          deleteContacts: bool = false): Recallable =
  ## peopleContactGroupsDelete
  ## Delete an existing contact group owned by the authenticated user by
  ## specifying a contact group resource name.
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
  ##   resourceName: string (required)
  ##               : The resource name of the contact group to delete.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   deleteContacts: bool
  ##                 : Set to true to also delete the contacts in the specified group.
  var path_579046 = newJObject()
  var query_579047 = newJObject()
  add(query_579047, "key", newJString(key))
  add(query_579047, "prettyPrint", newJBool(prettyPrint))
  add(query_579047, "oauth_token", newJString(oauthToken))
  add(query_579047, "$.xgafv", newJString(Xgafv))
  add(query_579047, "alt", newJString(alt))
  add(query_579047, "uploadType", newJString(uploadType))
  add(query_579047, "quotaUser", newJString(quotaUser))
  add(query_579047, "callback", newJString(callback))
  add(path_579046, "resourceName", newJString(resourceName))
  add(query_579047, "fields", newJString(fields))
  add(query_579047, "access_token", newJString(accessToken))
  add(query_579047, "upload_protocol", newJString(uploadProtocol))
  add(query_579047, "deleteContacts", newJBool(deleteContacts))
  result = call_579045.call(path_579046, query_579047, nil, nil, nil)

var peopleContactGroupsDelete* = Call_PeopleContactGroupsDelete_579028(
    name: "peopleContactGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "people.googleapis.com", route: "/v1/{resourceName}",
    validator: validate_PeopleContactGroupsDelete_579029, base: "/",
    url: url_PeopleContactGroupsDelete_579030, schemes: {Scheme.Https})
type
  Call_PeoplePeopleConnectionsList_579048 = ref object of OpenApiRestCall_578348
proc url_PeoplePeopleConnectionsList_579050(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/connections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeoplePeopleConnectionsList_579049(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides a list of the authenticated user's contacts merged with any
  ## connected profiles.
  ## <br>
  ## The request throws a 400 error if 'personFields' is not specified.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : The resource name to return connections for. Only `people/me` is valid.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_579051 = path.getOrDefault("resourceName")
  valid_579051 = validateParameter(valid_579051, JString, required = true,
                                 default = nil)
  if valid_579051 != nil:
    section.add "resourceName", valid_579051
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
  ##           : The number of connections to include in the response. Valid values are
  ## between 1 and 2000, inclusive. Defaults to 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token of the page to be returned.
  ##   sortOrder: JString
  ##            : The order in which the connections should be sorted. Defaults to
  ## `LAST_MODIFIED_ASCENDING`.
  ##   requestSyncToken: JBool
  ##                   : Whether the response should include a sync token, which can be used to get
  ## all changes since the last request. For subsequent sync requests use the
  ## `sync_token` param instead. Initial sync requests that specify
  ## `request_sync_token` have an additional rate limit.
  ##   callback: JString
  ##           : JSONP
  ##   requestMask.includeField: JString
  ##                           : **Required.** Comma-separated list of person fields to be included in the
  ## response. Each path should start with `person.`: for example,
  ## `person.names` or `person.photos`.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   syncToken: JString
  ##            : A sync token returned by a previous call to `people.connections.list`.
  ## Only resources changed since the sync token was created will be returned.
  ## Sync requests that specify `sync_token` have an additional rate limit.
  ##   personFields: JString
  ##               : **Required.** A field mask to restrict which fields on each person are
  ## returned. Multiple fields can be specified by separating them with commas.
  ## Valid values are:
  ## 
  ## * addresses
  ## * ageRanges
  ## * biographies
  ## * birthdays
  ## * braggingRights
  ## * coverPhotos
  ## * emailAddresses
  ## * events
  ## * genders
  ## * imClients
  ## * interests
  ## * locales
  ## * memberships
  ## * metadata
  ## * names
  ## * nicknames
  ## * occupations
  ## * organizations
  ## * phoneNumbers
  ## * photos
  ## * relations
  ## * relationshipInterests
  ## * relationshipStatuses
  ## * residences
  ## * sipAddresses
  ## * skills
  ## * taglines
  ## * urls
  ## * userDefined
  section = newJObject()
  var valid_579052 = query.getOrDefault("key")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "key", valid_579052
  var valid_579053 = query.getOrDefault("prettyPrint")
  valid_579053 = validateParameter(valid_579053, JBool, required = false,
                                 default = newJBool(true))
  if valid_579053 != nil:
    section.add "prettyPrint", valid_579053
  var valid_579054 = query.getOrDefault("oauth_token")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "oauth_token", valid_579054
  var valid_579055 = query.getOrDefault("$.xgafv")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = newJString("1"))
  if valid_579055 != nil:
    section.add "$.xgafv", valid_579055
  var valid_579056 = query.getOrDefault("pageSize")
  valid_579056 = validateParameter(valid_579056, JInt, required = false, default = nil)
  if valid_579056 != nil:
    section.add "pageSize", valid_579056
  var valid_579057 = query.getOrDefault("alt")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = newJString("json"))
  if valid_579057 != nil:
    section.add "alt", valid_579057
  var valid_579058 = query.getOrDefault("uploadType")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "uploadType", valid_579058
  var valid_579059 = query.getOrDefault("quotaUser")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "quotaUser", valid_579059
  var valid_579060 = query.getOrDefault("pageToken")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "pageToken", valid_579060
  var valid_579061 = query.getOrDefault("sortOrder")
  valid_579061 = validateParameter(valid_579061, JString, required = false, default = newJString(
      "LAST_MODIFIED_ASCENDING"))
  if valid_579061 != nil:
    section.add "sortOrder", valid_579061
  var valid_579062 = query.getOrDefault("requestSyncToken")
  valid_579062 = validateParameter(valid_579062, JBool, required = false, default = nil)
  if valid_579062 != nil:
    section.add "requestSyncToken", valid_579062
  var valid_579063 = query.getOrDefault("callback")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "callback", valid_579063
  var valid_579064 = query.getOrDefault("requestMask.includeField")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "requestMask.includeField", valid_579064
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
  var valid_579068 = query.getOrDefault("syncToken")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "syncToken", valid_579068
  var valid_579069 = query.getOrDefault("personFields")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "personFields", valid_579069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579070: Call_PeoplePeopleConnectionsList_579048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a list of the authenticated user's contacts merged with any
  ## connected profiles.
  ## <br>
  ## The request throws a 400 error if 'personFields' is not specified.
  ## 
  let valid = call_579070.validator(path, query, header, formData, body)
  let scheme = call_579070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579070.url(scheme.get, call_579070.host, call_579070.base,
                         call_579070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579070, url, valid)

proc call*(call_579071: Call_PeoplePeopleConnectionsList_579048;
          resourceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; sortOrder: string = "LAST_MODIFIED_ASCENDING";
          requestSyncToken: bool = false; callback: string = "";
          requestMaskIncludeField: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; syncToken: string = "";
          personFields: string = ""): Recallable =
  ## peoplePeopleConnectionsList
  ## Provides a list of the authenticated user's contacts merged with any
  ## connected profiles.
  ## <br>
  ## The request throws a 400 error if 'personFields' is not specified.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The number of connections to include in the response. Valid values are
  ## between 1 and 2000, inclusive. Defaults to 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The token of the page to be returned.
  ##   sortOrder: string
  ##            : The order in which the connections should be sorted. Defaults to
  ## `LAST_MODIFIED_ASCENDING`.
  ##   requestSyncToken: bool
  ##                   : Whether the response should include a sync token, which can be used to get
  ## all changes since the last request. For subsequent sync requests use the
  ## `sync_token` param instead. Initial sync requests that specify
  ## `request_sync_token` have an additional rate limit.
  ##   callback: string
  ##           : JSONP
  ##   resourceName: string (required)
  ##               : The resource name to return connections for. Only `people/me` is valid.
  ##   requestMaskIncludeField: string
  ##                          : **Required.** Comma-separated list of person fields to be included in the
  ## response. Each path should start with `person.`: for example,
  ## `person.names` or `person.photos`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   syncToken: string
  ##            : A sync token returned by a previous call to `people.connections.list`.
  ## Only resources changed since the sync token was created will be returned.
  ## Sync requests that specify `sync_token` have an additional rate limit.
  ##   personFields: string
  ##               : **Required.** A field mask to restrict which fields on each person are
  ## returned. Multiple fields can be specified by separating them with commas.
  ## Valid values are:
  ## 
  ## * addresses
  ## * ageRanges
  ## * biographies
  ## * birthdays
  ## * braggingRights
  ## * coverPhotos
  ## * emailAddresses
  ## * events
  ## * genders
  ## * imClients
  ## * interests
  ## * locales
  ## * memberships
  ## * metadata
  ## * names
  ## * nicknames
  ## * occupations
  ## * organizations
  ## * phoneNumbers
  ## * photos
  ## * relations
  ## * relationshipInterests
  ## * relationshipStatuses
  ## * residences
  ## * sipAddresses
  ## * skills
  ## * taglines
  ## * urls
  ## * userDefined
  var path_579072 = newJObject()
  var query_579073 = newJObject()
  add(query_579073, "key", newJString(key))
  add(query_579073, "prettyPrint", newJBool(prettyPrint))
  add(query_579073, "oauth_token", newJString(oauthToken))
  add(query_579073, "$.xgafv", newJString(Xgafv))
  add(query_579073, "pageSize", newJInt(pageSize))
  add(query_579073, "alt", newJString(alt))
  add(query_579073, "uploadType", newJString(uploadType))
  add(query_579073, "quotaUser", newJString(quotaUser))
  add(query_579073, "pageToken", newJString(pageToken))
  add(query_579073, "sortOrder", newJString(sortOrder))
  add(query_579073, "requestSyncToken", newJBool(requestSyncToken))
  add(query_579073, "callback", newJString(callback))
  add(path_579072, "resourceName", newJString(resourceName))
  add(query_579073, "requestMask.includeField",
      newJString(requestMaskIncludeField))
  add(query_579073, "fields", newJString(fields))
  add(query_579073, "access_token", newJString(accessToken))
  add(query_579073, "upload_protocol", newJString(uploadProtocol))
  add(query_579073, "syncToken", newJString(syncToken))
  add(query_579073, "personFields", newJString(personFields))
  result = call_579071.call(path_579072, query_579073, nil, nil, nil)

var peoplePeopleConnectionsList* = Call_PeoplePeopleConnectionsList_579048(
    name: "peoplePeopleConnectionsList", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/{resourceName}/connections",
    validator: validate_PeoplePeopleConnectionsList_579049, base: "/",
    url: url_PeoplePeopleConnectionsList_579050, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsMembersModify_579074 = ref object of OpenApiRestCall_578348
proc url_PeopleContactGroupsMembersModify_579076(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/members:modify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeopleContactGroupsMembersModify_579075(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify the members of a contact group owned by the authenticated user.
  ## <br>
  ## The only system contact groups that can have members added are
  ## `contactGroups/myContacts` and `contactGroups/starred`. Other system
  ## contact groups are deprecated and can only have contacts removed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : The resource name of the contact group to modify.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_579077 = path.getOrDefault("resourceName")
  valid_579077 = validateParameter(valid_579077, JString, required = true,
                                 default = nil)
  if valid_579077 != nil:
    section.add "resourceName", valid_579077
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
  var valid_579082 = query.getOrDefault("alt")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = newJString("json"))
  if valid_579082 != nil:
    section.add "alt", valid_579082
  var valid_579083 = query.getOrDefault("uploadType")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "uploadType", valid_579083
  var valid_579084 = query.getOrDefault("quotaUser")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "quotaUser", valid_579084
  var valid_579085 = query.getOrDefault("callback")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "callback", valid_579085
  var valid_579086 = query.getOrDefault("fields")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "fields", valid_579086
  var valid_579087 = query.getOrDefault("access_token")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "access_token", valid_579087
  var valid_579088 = query.getOrDefault("upload_protocol")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "upload_protocol", valid_579088
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

proc call*(call_579090: Call_PeopleContactGroupsMembersModify_579074;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modify the members of a contact group owned by the authenticated user.
  ## <br>
  ## The only system contact groups that can have members added are
  ## `contactGroups/myContacts` and `contactGroups/starred`. Other system
  ## contact groups are deprecated and can only have contacts removed.
  ## 
  let valid = call_579090.validator(path, query, header, formData, body)
  let scheme = call_579090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579090.url(scheme.get, call_579090.host, call_579090.base,
                         call_579090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579090, url, valid)

proc call*(call_579091: Call_PeopleContactGroupsMembersModify_579074;
          resourceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## peopleContactGroupsMembersModify
  ## Modify the members of a contact group owned by the authenticated user.
  ## <br>
  ## The only system contact groups that can have members added are
  ## `contactGroups/myContacts` and `contactGroups/starred`. Other system
  ## contact groups are deprecated and can only have contacts removed.
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
  ##   resourceName: string (required)
  ##               : The resource name of the contact group to modify.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579092 = newJObject()
  var query_579093 = newJObject()
  var body_579094 = newJObject()
  add(query_579093, "key", newJString(key))
  add(query_579093, "prettyPrint", newJBool(prettyPrint))
  add(query_579093, "oauth_token", newJString(oauthToken))
  add(query_579093, "$.xgafv", newJString(Xgafv))
  add(query_579093, "alt", newJString(alt))
  add(query_579093, "uploadType", newJString(uploadType))
  add(query_579093, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579094 = body
  add(query_579093, "callback", newJString(callback))
  add(path_579092, "resourceName", newJString(resourceName))
  add(query_579093, "fields", newJString(fields))
  add(query_579093, "access_token", newJString(accessToken))
  add(query_579093, "upload_protocol", newJString(uploadProtocol))
  result = call_579091.call(path_579092, query_579093, nil, nil, body_579094)

var peopleContactGroupsMembersModify* = Call_PeopleContactGroupsMembersModify_579074(
    name: "peopleContactGroupsMembersModify", meth: HttpMethod.HttpPost,
    host: "people.googleapis.com", route: "/v1/{resourceName}/members:modify",
    validator: validate_PeopleContactGroupsMembersModify_579075, base: "/",
    url: url_PeopleContactGroupsMembersModify_579076, schemes: {Scheme.Https})
type
  Call_PeoplePeopleDeleteContact_579095 = ref object of OpenApiRestCall_578348
proc url_PeoplePeopleDeleteContact_579097(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: ":deleteContact")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeoplePeopleDeleteContact_579096(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a contact person. Any non-contact data will not be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : The resource name of the contact to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_579098 = path.getOrDefault("resourceName")
  valid_579098 = validateParameter(valid_579098, JString, required = true,
                                 default = nil)
  if valid_579098 != nil:
    section.add "resourceName", valid_579098
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
  if body != nil:
    result.add "body", body

proc call*(call_579110: Call_PeoplePeopleDeleteContact_579095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a contact person. Any non-contact data will not be deleted.
  ## 
  let valid = call_579110.validator(path, query, header, formData, body)
  let scheme = call_579110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579110.url(scheme.get, call_579110.host, call_579110.base,
                         call_579110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579110, url, valid)

proc call*(call_579111: Call_PeoplePeopleDeleteContact_579095;
          resourceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## peoplePeopleDeleteContact
  ## Delete a contact person. Any non-contact data will not be deleted.
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
  ##   resourceName: string (required)
  ##               : The resource name of the contact to delete.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579112 = newJObject()
  var query_579113 = newJObject()
  add(query_579113, "key", newJString(key))
  add(query_579113, "prettyPrint", newJBool(prettyPrint))
  add(query_579113, "oauth_token", newJString(oauthToken))
  add(query_579113, "$.xgafv", newJString(Xgafv))
  add(query_579113, "alt", newJString(alt))
  add(query_579113, "uploadType", newJString(uploadType))
  add(query_579113, "quotaUser", newJString(quotaUser))
  add(query_579113, "callback", newJString(callback))
  add(path_579112, "resourceName", newJString(resourceName))
  add(query_579113, "fields", newJString(fields))
  add(query_579113, "access_token", newJString(accessToken))
  add(query_579113, "upload_protocol", newJString(uploadProtocol))
  result = call_579111.call(path_579112, query_579113, nil, nil, nil)

var peoplePeopleDeleteContact* = Call_PeoplePeopleDeleteContact_579095(
    name: "peoplePeopleDeleteContact", meth: HttpMethod.HttpDelete,
    host: "people.googleapis.com", route: "/v1/{resourceName}:deleteContact",
    validator: validate_PeoplePeopleDeleteContact_579096, base: "/",
    url: url_PeoplePeopleDeleteContact_579097, schemes: {Scheme.Https})
type
  Call_PeoplePeopleDeleteContactPhoto_579114 = ref object of OpenApiRestCall_578348
proc url_PeoplePeopleDeleteContactPhoto_579116(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: ":deleteContactPhoto")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeoplePeopleDeleteContactPhoto_579115(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a contact's photo.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : The resource name of the contact whose photo will be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_579117 = path.getOrDefault("resourceName")
  valid_579117 = validateParameter(valid_579117, JString, required = true,
                                 default = nil)
  if valid_579117 != nil:
    section.add "resourceName", valid_579117
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
  ##   personFields: JString
  ##               : **Optional.** Not specifying any fields will skip the post mutate read.
  ## A field mask to restrict which fields on the person are
  ## returned. Multiple fields can be specified by separating them with commas.
  ## Valid values are:
  ## 
  ## * addresses
  ## * ageRanges
  ## * biographies
  ## * birthdays
  ## * braggingRights
  ## * coverPhotos
  ## * emailAddresses
  ## * events
  ## * genders
  ## * imClients
  ## * interests
  ## * locales
  ## * memberships
  ## * metadata
  ## * names
  ## * nicknames
  ## * occupations
  ## * organizations
  ## * phoneNumbers
  ## * photos
  ## * relations
  ## * relationshipInterests
  ## * relationshipStatuses
  ## * residences
  ## * sipAddresses
  ## * skills
  ## * taglines
  ## * urls
  ## * userDefined
  section = newJObject()
  var valid_579118 = query.getOrDefault("key")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "key", valid_579118
  var valid_579119 = query.getOrDefault("prettyPrint")
  valid_579119 = validateParameter(valid_579119, JBool, required = false,
                                 default = newJBool(true))
  if valid_579119 != nil:
    section.add "prettyPrint", valid_579119
  var valid_579120 = query.getOrDefault("oauth_token")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "oauth_token", valid_579120
  var valid_579121 = query.getOrDefault("$.xgafv")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = newJString("1"))
  if valid_579121 != nil:
    section.add "$.xgafv", valid_579121
  var valid_579122 = query.getOrDefault("alt")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = newJString("json"))
  if valid_579122 != nil:
    section.add "alt", valid_579122
  var valid_579123 = query.getOrDefault("uploadType")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "uploadType", valid_579123
  var valid_579124 = query.getOrDefault("quotaUser")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "quotaUser", valid_579124
  var valid_579125 = query.getOrDefault("callback")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "callback", valid_579125
  var valid_579126 = query.getOrDefault("fields")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "fields", valid_579126
  var valid_579127 = query.getOrDefault("access_token")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "access_token", valid_579127
  var valid_579128 = query.getOrDefault("upload_protocol")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "upload_protocol", valid_579128
  var valid_579129 = query.getOrDefault("personFields")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "personFields", valid_579129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579130: Call_PeoplePeopleDeleteContactPhoto_579114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a contact's photo.
  ## 
  let valid = call_579130.validator(path, query, header, formData, body)
  let scheme = call_579130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579130.url(scheme.get, call_579130.host, call_579130.base,
                         call_579130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579130, url, valid)

proc call*(call_579131: Call_PeoplePeopleDeleteContactPhoto_579114;
          resourceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          personFields: string = ""): Recallable =
  ## peoplePeopleDeleteContactPhoto
  ## Delete a contact's photo.
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
  ##   resourceName: string (required)
  ##               : The resource name of the contact whose photo will be deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   personFields: string
  ##               : **Optional.** Not specifying any fields will skip the post mutate read.
  ## A field mask to restrict which fields on the person are
  ## returned. Multiple fields can be specified by separating them with commas.
  ## Valid values are:
  ## 
  ## * addresses
  ## * ageRanges
  ## * biographies
  ## * birthdays
  ## * braggingRights
  ## * coverPhotos
  ## * emailAddresses
  ## * events
  ## * genders
  ## * imClients
  ## * interests
  ## * locales
  ## * memberships
  ## * metadata
  ## * names
  ## * nicknames
  ## * occupations
  ## * organizations
  ## * phoneNumbers
  ## * photos
  ## * relations
  ## * relationshipInterests
  ## * relationshipStatuses
  ## * residences
  ## * sipAddresses
  ## * skills
  ## * taglines
  ## * urls
  ## * userDefined
  var path_579132 = newJObject()
  var query_579133 = newJObject()
  add(query_579133, "key", newJString(key))
  add(query_579133, "prettyPrint", newJBool(prettyPrint))
  add(query_579133, "oauth_token", newJString(oauthToken))
  add(query_579133, "$.xgafv", newJString(Xgafv))
  add(query_579133, "alt", newJString(alt))
  add(query_579133, "uploadType", newJString(uploadType))
  add(query_579133, "quotaUser", newJString(quotaUser))
  add(query_579133, "callback", newJString(callback))
  add(path_579132, "resourceName", newJString(resourceName))
  add(query_579133, "fields", newJString(fields))
  add(query_579133, "access_token", newJString(accessToken))
  add(query_579133, "upload_protocol", newJString(uploadProtocol))
  add(query_579133, "personFields", newJString(personFields))
  result = call_579131.call(path_579132, query_579133, nil, nil, nil)

var peoplePeopleDeleteContactPhoto* = Call_PeoplePeopleDeleteContactPhoto_579114(
    name: "peoplePeopleDeleteContactPhoto", meth: HttpMethod.HttpDelete,
    host: "people.googleapis.com", route: "/v1/{resourceName}:deleteContactPhoto",
    validator: validate_PeoplePeopleDeleteContactPhoto_579115, base: "/",
    url: url_PeoplePeopleDeleteContactPhoto_579116, schemes: {Scheme.Https})
type
  Call_PeoplePeopleUpdateContact_579134 = ref object of OpenApiRestCall_578348
proc url_PeoplePeopleUpdateContact_579136(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: ":updateContact")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeoplePeopleUpdateContact_579135(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update contact data for an existing contact person. Any non-contact data
  ## will not be modified.
  ## 
  ## The request throws a 400 error if `updatePersonFields` is not specified.
  ## <br>
  ## The request throws a 400 error if `person.metadata.sources` is not
  ## specified for the contact to be updated.
  ## <br>
  ## The request throws a 400 error with an error with reason
  ## `"failedPrecondition"` if `person.metadata.sources.etag` is different than
  ## the contact's etag, which indicates the contact has changed since its data
  ## was read. Clients should get the latest person and re-apply their updates
  ## to the latest person.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : The resource name for the person, assigned by the server. An ASCII string
  ## with a max length of 27 characters, in the form of
  ## `people/`<var>person_id</var>.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_579137 = path.getOrDefault("resourceName")
  valid_579137 = validateParameter(valid_579137, JString, required = true,
                                 default = nil)
  if valid_579137 != nil:
    section.add "resourceName", valid_579137
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
  ##   updatePersonFields: JString
  ##                     : **Required.** A field mask to restrict which fields on the person are
  ## updated. Multiple fields can be specified by separating them with commas.
  ## All updated fields will be replaced. Valid values are:
  ## 
  ## * addresses
  ## * biographies
  ## * birthdays
  ## * emailAddresses
  ## * events
  ## * genders
  ## * imClients
  ## * interests
  ## * locales
  ## * memberships
  ## * names
  ## * nicknames
  ## * occupations
  ## * organizations
  ## * phoneNumbers
  ## * relations
  ## * residences
  ## * sipAddresses
  ## * urls
  ## * userDefined
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579138 = query.getOrDefault("key")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "key", valid_579138
  var valid_579139 = query.getOrDefault("prettyPrint")
  valid_579139 = validateParameter(valid_579139, JBool, required = false,
                                 default = newJBool(true))
  if valid_579139 != nil:
    section.add "prettyPrint", valid_579139
  var valid_579140 = query.getOrDefault("oauth_token")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "oauth_token", valid_579140
  var valid_579141 = query.getOrDefault("$.xgafv")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = newJString("1"))
  if valid_579141 != nil:
    section.add "$.xgafv", valid_579141
  var valid_579142 = query.getOrDefault("alt")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = newJString("json"))
  if valid_579142 != nil:
    section.add "alt", valid_579142
  var valid_579143 = query.getOrDefault("uploadType")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "uploadType", valid_579143
  var valid_579144 = query.getOrDefault("quotaUser")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "quotaUser", valid_579144
  var valid_579145 = query.getOrDefault("updatePersonFields")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "updatePersonFields", valid_579145
  var valid_579146 = query.getOrDefault("callback")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "callback", valid_579146
  var valid_579147 = query.getOrDefault("fields")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "fields", valid_579147
  var valid_579148 = query.getOrDefault("access_token")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "access_token", valid_579148
  var valid_579149 = query.getOrDefault("upload_protocol")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "upload_protocol", valid_579149
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

proc call*(call_579151: Call_PeoplePeopleUpdateContact_579134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update contact data for an existing contact person. Any non-contact data
  ## will not be modified.
  ## 
  ## The request throws a 400 error if `updatePersonFields` is not specified.
  ## <br>
  ## The request throws a 400 error if `person.metadata.sources` is not
  ## specified for the contact to be updated.
  ## <br>
  ## The request throws a 400 error with an error with reason
  ## `"failedPrecondition"` if `person.metadata.sources.etag` is different than
  ## the contact's etag, which indicates the contact has changed since its data
  ## was read. Clients should get the latest person and re-apply their updates
  ## to the latest person.
  ## 
  let valid = call_579151.validator(path, query, header, formData, body)
  let scheme = call_579151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579151.url(scheme.get, call_579151.host, call_579151.base,
                         call_579151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579151, url, valid)

proc call*(call_579152: Call_PeoplePeopleUpdateContact_579134;
          resourceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = "";
          updatePersonFields: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## peoplePeopleUpdateContact
  ## Update contact data for an existing contact person. Any non-contact data
  ## will not be modified.
  ## 
  ## The request throws a 400 error if `updatePersonFields` is not specified.
  ## <br>
  ## The request throws a 400 error if `person.metadata.sources` is not
  ## specified for the contact to be updated.
  ## <br>
  ## The request throws a 400 error with an error with reason
  ## `"failedPrecondition"` if `person.metadata.sources.etag` is different than
  ## the contact's etag, which indicates the contact has changed since its data
  ## was read. Clients should get the latest person and re-apply their updates
  ## to the latest person.
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
  ##   updatePersonFields: string
  ##                     : **Required.** A field mask to restrict which fields on the person are
  ## updated. Multiple fields can be specified by separating them with commas.
  ## All updated fields will be replaced. Valid values are:
  ## 
  ## * addresses
  ## * biographies
  ## * birthdays
  ## * emailAddresses
  ## * events
  ## * genders
  ## * imClients
  ## * interests
  ## * locales
  ## * memberships
  ## * names
  ## * nicknames
  ## * occupations
  ## * organizations
  ## * phoneNumbers
  ## * relations
  ## * residences
  ## * sipAddresses
  ## * urls
  ## * userDefined
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   resourceName: string (required)
  ##               : The resource name for the person, assigned by the server. An ASCII string
  ## with a max length of 27 characters, in the form of
  ## `people/`<var>person_id</var>.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579153 = newJObject()
  var query_579154 = newJObject()
  var body_579155 = newJObject()
  add(query_579154, "key", newJString(key))
  add(query_579154, "prettyPrint", newJBool(prettyPrint))
  add(query_579154, "oauth_token", newJString(oauthToken))
  add(query_579154, "$.xgafv", newJString(Xgafv))
  add(query_579154, "alt", newJString(alt))
  add(query_579154, "uploadType", newJString(uploadType))
  add(query_579154, "quotaUser", newJString(quotaUser))
  add(query_579154, "updatePersonFields", newJString(updatePersonFields))
  if body != nil:
    body_579155 = body
  add(query_579154, "callback", newJString(callback))
  add(path_579153, "resourceName", newJString(resourceName))
  add(query_579154, "fields", newJString(fields))
  add(query_579154, "access_token", newJString(accessToken))
  add(query_579154, "upload_protocol", newJString(uploadProtocol))
  result = call_579152.call(path_579153, query_579154, nil, nil, body_579155)

var peoplePeopleUpdateContact* = Call_PeoplePeopleUpdateContact_579134(
    name: "peoplePeopleUpdateContact", meth: HttpMethod.HttpPatch,
    host: "people.googleapis.com", route: "/v1/{resourceName}:updateContact",
    validator: validate_PeoplePeopleUpdateContact_579135, base: "/",
    url: url_PeoplePeopleUpdateContact_579136, schemes: {Scheme.Https})
type
  Call_PeoplePeopleUpdateContactPhoto_579156 = ref object of OpenApiRestCall_578348
proc url_PeoplePeopleUpdateContactPhoto_579158(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: ":updateContactPhoto")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeoplePeopleUpdateContactPhoto_579157(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a contact's photo.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : Person resource name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_579159 = path.getOrDefault("resourceName")
  valid_579159 = validateParameter(valid_579159, JString, required = true,
                                 default = nil)
  if valid_579159 != nil:
    section.add "resourceName", valid_579159
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
  var valid_579160 = query.getOrDefault("key")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "key", valid_579160
  var valid_579161 = query.getOrDefault("prettyPrint")
  valid_579161 = validateParameter(valid_579161, JBool, required = false,
                                 default = newJBool(true))
  if valid_579161 != nil:
    section.add "prettyPrint", valid_579161
  var valid_579162 = query.getOrDefault("oauth_token")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "oauth_token", valid_579162
  var valid_579163 = query.getOrDefault("$.xgafv")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = newJString("1"))
  if valid_579163 != nil:
    section.add "$.xgafv", valid_579163
  var valid_579164 = query.getOrDefault("alt")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = newJString("json"))
  if valid_579164 != nil:
    section.add "alt", valid_579164
  var valid_579165 = query.getOrDefault("uploadType")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "uploadType", valid_579165
  var valid_579166 = query.getOrDefault("quotaUser")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "quotaUser", valid_579166
  var valid_579167 = query.getOrDefault("callback")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "callback", valid_579167
  var valid_579168 = query.getOrDefault("fields")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "fields", valid_579168
  var valid_579169 = query.getOrDefault("access_token")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "access_token", valid_579169
  var valid_579170 = query.getOrDefault("upload_protocol")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "upload_protocol", valid_579170
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

proc call*(call_579172: Call_PeoplePeopleUpdateContactPhoto_579156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a contact's photo.
  ## 
  let valid = call_579172.validator(path, query, header, formData, body)
  let scheme = call_579172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579172.url(scheme.get, call_579172.host, call_579172.base,
                         call_579172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579172, url, valid)

proc call*(call_579173: Call_PeoplePeopleUpdateContactPhoto_579156;
          resourceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## peoplePeopleUpdateContactPhoto
  ## Update a contact's photo.
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
  ##   resourceName: string (required)
  ##               : Person resource name
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579174 = newJObject()
  var query_579175 = newJObject()
  var body_579176 = newJObject()
  add(query_579175, "key", newJString(key))
  add(query_579175, "prettyPrint", newJBool(prettyPrint))
  add(query_579175, "oauth_token", newJString(oauthToken))
  add(query_579175, "$.xgafv", newJString(Xgafv))
  add(query_579175, "alt", newJString(alt))
  add(query_579175, "uploadType", newJString(uploadType))
  add(query_579175, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579176 = body
  add(query_579175, "callback", newJString(callback))
  add(path_579174, "resourceName", newJString(resourceName))
  add(query_579175, "fields", newJString(fields))
  add(query_579175, "access_token", newJString(accessToken))
  add(query_579175, "upload_protocol", newJString(uploadProtocol))
  result = call_579173.call(path_579174, query_579175, nil, nil, body_579176)

var peoplePeopleUpdateContactPhoto* = Call_PeoplePeopleUpdateContactPhoto_579156(
    name: "peoplePeopleUpdateContactPhoto", meth: HttpMethod.HttpPatch,
    host: "people.googleapis.com", route: "/v1/{resourceName}:updateContactPhoto",
    validator: validate_PeoplePeopleUpdateContactPhoto_579157, base: "/",
    url: url_PeoplePeopleUpdateContactPhoto_579158, schemes: {Scheme.Https})
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
