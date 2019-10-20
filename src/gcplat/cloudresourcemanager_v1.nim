
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Resource Manager
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Creates, reads, and updates metadata for Google Cloud Platform resource containers.
## 
## https://cloud.google.com/resource-manager
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
  gcpServiceName = "cloudresourcemanager"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudresourcemanagerLiensCreate_578894 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerLiensCreate_578896(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerLiensCreate_578895(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a Lien which applies to the resource denoted by the `parent` field.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, applying to `projects/1234` requires permission
  ## `resourcemanager.projects.updateLiens`.
  ## 
  ## NOTE: Some resources may limit the number of Liens which may be applied.
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

proc call*(call_578909: Call_CloudresourcemanagerLiensCreate_578894;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a Lien which applies to the resource denoted by the `parent` field.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, applying to `projects/1234` requires permission
  ## `resourcemanager.projects.updateLiens`.
  ## 
  ## NOTE: Some resources may limit the number of Liens which may be applied.
  ## 
  let valid = call_578909.validator(path, query, header, formData, body)
  let scheme = call_578909.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578909.url(scheme.get, call_578909.host, call_578909.base,
                         call_578909.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578909, url, valid)

proc call*(call_578910: Call_CloudresourcemanagerLiensCreate_578894;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerLiensCreate
  ## Create a Lien which applies to the resource denoted by the `parent` field.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, applying to `projects/1234` requires permission
  ## `resourcemanager.projects.updateLiens`.
  ## 
  ## NOTE: Some resources may limit the number of Liens which may be applied.
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

var cloudresourcemanagerLiensCreate* = Call_CloudresourcemanagerLiensCreate_578894(
    name: "cloudresourcemanagerLiensCreate", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/liens",
    validator: validate_CloudresourcemanagerLiensCreate_578895, base: "/",
    url: url_CloudresourcemanagerLiensCreate_578896, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerLiensList_578619 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerLiensList_578621(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerLiensList_578620(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all Liens applied to the `parent` resource.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, a Lien with a `parent` of `projects/1234` requires permission
  ## `resourcemanager.projects.get`.
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
  ##           : The maximum number of items to return. This is a suggestion for the server.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The name of the resource to list all attached Liens.
  ## For example, `projects/1234`.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The `next_page_token` value returned from a previous List request, if any.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
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
  var valid_578753 = query.getOrDefault("parent")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "parent", valid_578753
  var valid_578754 = query.getOrDefault("quotaUser")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "quotaUser", valid_578754
  var valid_578755 = query.getOrDefault("pageToken")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "pageToken", valid_578755
  var valid_578756 = query.getOrDefault("callback")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "callback", valid_578756
  var valid_578757 = query.getOrDefault("fields")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "fields", valid_578757
  var valid_578758 = query.getOrDefault("access_token")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "access_token", valid_578758
  var valid_578759 = query.getOrDefault("upload_protocol")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "upload_protocol", valid_578759
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578782: Call_CloudresourcemanagerLiensList_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all Liens applied to the `parent` resource.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, a Lien with a `parent` of `projects/1234` requires permission
  ## `resourcemanager.projects.get`.
  ## 
  let valid = call_578782.validator(path, query, header, formData, body)
  let scheme = call_578782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578782.url(scheme.get, call_578782.host, call_578782.base,
                         call_578782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578782, url, valid)

proc call*(call_578853: Call_CloudresourcemanagerLiensList_578619;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerLiensList
  ## List all Liens applied to the `parent` resource.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, a Lien with a `parent` of `projects/1234` requires permission
  ## `resourcemanager.projects.get`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return. This is a suggestion for the server.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The name of the resource to list all attached Liens.
  ## For example, `projects/1234`.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The `next_page_token` value returned from a previous List request, if any.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578854 = newJObject()
  add(query_578854, "key", newJString(key))
  add(query_578854, "prettyPrint", newJBool(prettyPrint))
  add(query_578854, "oauth_token", newJString(oauthToken))
  add(query_578854, "$.xgafv", newJString(Xgafv))
  add(query_578854, "pageSize", newJInt(pageSize))
  add(query_578854, "alt", newJString(alt))
  add(query_578854, "uploadType", newJString(uploadType))
  add(query_578854, "parent", newJString(parent))
  add(query_578854, "quotaUser", newJString(quotaUser))
  add(query_578854, "pageToken", newJString(pageToken))
  add(query_578854, "callback", newJString(callback))
  add(query_578854, "fields", newJString(fields))
  add(query_578854, "access_token", newJString(accessToken))
  add(query_578854, "upload_protocol", newJString(uploadProtocol))
  result = call_578853.call(nil, query_578854, nil, nil, nil)

var cloudresourcemanagerLiensList* = Call_CloudresourcemanagerLiensList_578619(
    name: "cloudresourcemanagerLiensList", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/liens",
    validator: validate_CloudresourcemanagerLiensList_578620, base: "/",
    url: url_CloudresourcemanagerLiensList_578621, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsSearch_578913 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerOrganizationsSearch_578915(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerOrganizationsSearch_578914(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Searches Organization resources that are visible to the user and satisfy
  ## the specified filter. This method returns Organizations in an unspecified
  ## order. New Organizations do not necessarily appear at the end of the
  ## results.
  ## 
  ## Search will only return organizations on which the user has the permission
  ## `resourcemanager.organizations.get`
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
  var valid_578923 = query.getOrDefault("callback")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "callback", valid_578923
  var valid_578924 = query.getOrDefault("fields")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "fields", valid_578924
  var valid_578925 = query.getOrDefault("access_token")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "access_token", valid_578925
  var valid_578926 = query.getOrDefault("upload_protocol")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "upload_protocol", valid_578926
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

proc call*(call_578928: Call_CloudresourcemanagerOrganizationsSearch_578913;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Searches Organization resources that are visible to the user and satisfy
  ## the specified filter. This method returns Organizations in an unspecified
  ## order. New Organizations do not necessarily appear at the end of the
  ## results.
  ## 
  ## Search will only return organizations on which the user has the permission
  ## `resourcemanager.organizations.get`
  ## 
  let valid = call_578928.validator(path, query, header, formData, body)
  let scheme = call_578928.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578928.url(scheme.get, call_578928.host, call_578928.base,
                         call_578928.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578928, url, valid)

proc call*(call_578929: Call_CloudresourcemanagerOrganizationsSearch_578913;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerOrganizationsSearch
  ## Searches Organization resources that are visible to the user and satisfy
  ## the specified filter. This method returns Organizations in an unspecified
  ## order. New Organizations do not necessarily appear at the end of the
  ## results.
  ## 
  ## Search will only return organizations on which the user has the permission
  ## `resourcemanager.organizations.get`
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
  var query_578930 = newJObject()
  var body_578931 = newJObject()
  add(query_578930, "key", newJString(key))
  add(query_578930, "prettyPrint", newJBool(prettyPrint))
  add(query_578930, "oauth_token", newJString(oauthToken))
  add(query_578930, "$.xgafv", newJString(Xgafv))
  add(query_578930, "alt", newJString(alt))
  add(query_578930, "uploadType", newJString(uploadType))
  add(query_578930, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578931 = body
  add(query_578930, "callback", newJString(callback))
  add(query_578930, "fields", newJString(fields))
  add(query_578930, "access_token", newJString(accessToken))
  add(query_578930, "upload_protocol", newJString(uploadProtocol))
  result = call_578929.call(nil, query_578930, nil, nil, body_578931)

var cloudresourcemanagerOrganizationsSearch* = Call_CloudresourcemanagerOrganizationsSearch_578913(
    name: "cloudresourcemanagerOrganizationsSearch", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/organizations:search",
    validator: validate_CloudresourcemanagerOrganizationsSearch_578914, base: "/",
    url: url_CloudresourcemanagerOrganizationsSearch_578915,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsCreate_578952 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerProjectsCreate_578954(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerProjectsCreate_578953(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Request that a new Project be created. The result is an Operation which
  ## can be used to track the creation process. This process usually takes a few
  ## seconds, but can sometimes take much longer. The tracking Operation is
  ## automatically deleted after a few hours, so there is no need to call
  ## DeleteOperation.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.create` on the specified parent for the new
  ## project. The parent is identified by a specified ResourceId,
  ## which must include both an ID and a type, such as organization.
  ## 
  ## This method does not associate the new project with a billing account.
  ## You can set or update the billing account associated with a project using
  ## the [`projects.updateBillingInfo`]
  ## (/billing/reference/rest/v1/projects/updateBillingInfo) method.
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
  var valid_578961 = query.getOrDefault("quotaUser")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "quotaUser", valid_578961
  var valid_578962 = query.getOrDefault("callback")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "callback", valid_578962
  var valid_578963 = query.getOrDefault("fields")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "fields", valid_578963
  var valid_578964 = query.getOrDefault("access_token")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "access_token", valid_578964
  var valid_578965 = query.getOrDefault("upload_protocol")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "upload_protocol", valid_578965
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

proc call*(call_578967: Call_CloudresourcemanagerProjectsCreate_578952;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request that a new Project be created. The result is an Operation which
  ## can be used to track the creation process. This process usually takes a few
  ## seconds, but can sometimes take much longer. The tracking Operation is
  ## automatically deleted after a few hours, so there is no need to call
  ## DeleteOperation.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.create` on the specified parent for the new
  ## project. The parent is identified by a specified ResourceId,
  ## which must include both an ID and a type, such as organization.
  ## 
  ## This method does not associate the new project with a billing account.
  ## You can set or update the billing account associated with a project using
  ## the [`projects.updateBillingInfo`]
  ## (/billing/reference/rest/v1/projects/updateBillingInfo) method.
  ## 
  let valid = call_578967.validator(path, query, header, formData, body)
  let scheme = call_578967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578967.url(scheme.get, call_578967.host, call_578967.base,
                         call_578967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578967, url, valid)

proc call*(call_578968: Call_CloudresourcemanagerProjectsCreate_578952;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerProjectsCreate
  ## Request that a new Project be created. The result is an Operation which
  ## can be used to track the creation process. This process usually takes a few
  ## seconds, but can sometimes take much longer. The tracking Operation is
  ## automatically deleted after a few hours, so there is no need to call
  ## DeleteOperation.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.create` on the specified parent for the new
  ## project. The parent is identified by a specified ResourceId,
  ## which must include both an ID and a type, such as organization.
  ## 
  ## This method does not associate the new project with a billing account.
  ## You can set or update the billing account associated with a project using
  ## the [`projects.updateBillingInfo`]
  ## (/billing/reference/rest/v1/projects/updateBillingInfo) method.
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
  var query_578969 = newJObject()
  var body_578970 = newJObject()
  add(query_578969, "key", newJString(key))
  add(query_578969, "prettyPrint", newJBool(prettyPrint))
  add(query_578969, "oauth_token", newJString(oauthToken))
  add(query_578969, "$.xgafv", newJString(Xgafv))
  add(query_578969, "alt", newJString(alt))
  add(query_578969, "uploadType", newJString(uploadType))
  add(query_578969, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578970 = body
  add(query_578969, "callback", newJString(callback))
  add(query_578969, "fields", newJString(fields))
  add(query_578969, "access_token", newJString(accessToken))
  add(query_578969, "upload_protocol", newJString(uploadProtocol))
  result = call_578968.call(nil, query_578969, nil, nil, body_578970)

var cloudresourcemanagerProjectsCreate* = Call_CloudresourcemanagerProjectsCreate_578952(
    name: "cloudresourcemanagerProjectsCreate", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/projects",
    validator: validate_CloudresourcemanagerProjectsCreate_578953, base: "/",
    url: url_CloudresourcemanagerProjectsCreate_578954, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsList_578932 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerProjectsList_578934(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerProjectsList_578933(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists Projects that the caller has the `resourcemanager.projects.get`
  ## permission on and satisfy the specified filter.
  ## 
  ## This method returns Projects in an unspecified order.
  ## This method is eventually consistent with project mutations; this means
  ## that a newly created project may not appear in the results or recent
  ## updates to an existing project may not be reflected in the results. To
  ## retrieve the latest state of a project, use the
  ## GetProject method.
  ## 
  ## NOTE: If the request filter contains a `parent.type` and `parent.id` and
  ## the caller has the `resourcemanager.projects.list` permission on the
  ## parent, the results will be drawn from an alternate index which provides
  ## more consistent results. In future versions of this API, this List method
  ## will be split into List and Search to properly capture the behavorial
  ## difference.
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
  ##           : The maximum number of Projects to return in the response.
  ## The server can return fewer Projects than requested.
  ## If unspecified, server picks an appropriate default.
  ## 
  ## Optional.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : An expression for filtering the results of the request.  Filter rules are
  ## case insensitive. The fields eligible for filtering are:
  ## 
  ## + `name`
  ## + `id`
  ## + `labels.<key>` (where *key* is the name of a label)
  ## + `parent.type`
  ## + `parent.id`
  ## 
  ## Some examples of using labels as filters:
  ## 
  ## | Filter           | Description                                         |
  ## |------------------|-----------------------------------------------------|
  ## | name:how*        | The project's name starts with "how".               |
  ## | name:Howl        | The project's name is `Howl` or `howl`.             |
  ## | name:HOWL        | Equivalent to above.                                |
  ## | NAME:howl        | Equivalent to above.                                |
  ## | labels.color:*   | The project has the label `color`.                  |
  ## | labels.color:red | The project's label `color` has the value `red`.    |
  ## | labels.color:red&nbsp;labels.size:big |The project's label `color` has
  ##   the value `red` and its label `size` has the value `big`.              |
  ## 
  ## If no filter is specified, the call will return projects for which the user
  ## has the `resourcemanager.projects.get` permission.
  ## 
  ## NOTE: To perform a by-parent query (eg., what projects are directly in a
  ## Folder), the caller must have the `resourcemanager.projects.list`
  ## permission on the parent and the filter must contain both a `parent.type`
  ## and a `parent.id` restriction
  ## (example: "parent.type:folder parent.id:123"). In this case an alternate
  ## search index is used which provides more consistent results.
  ## 
  ## Optional.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to ListProjects
  ## that indicates from where listing should continue.
  ## 
  ## Optional.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
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
  var valid_578939 = query.getOrDefault("pageSize")
  valid_578939 = validateParameter(valid_578939, JInt, required = false, default = nil)
  if valid_578939 != nil:
    section.add "pageSize", valid_578939
  var valid_578940 = query.getOrDefault("alt")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = newJString("json"))
  if valid_578940 != nil:
    section.add "alt", valid_578940
  var valid_578941 = query.getOrDefault("uploadType")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "uploadType", valid_578941
  var valid_578942 = query.getOrDefault("quotaUser")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "quotaUser", valid_578942
  var valid_578943 = query.getOrDefault("filter")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "filter", valid_578943
  var valid_578944 = query.getOrDefault("pageToken")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "pageToken", valid_578944
  var valid_578945 = query.getOrDefault("callback")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "callback", valid_578945
  var valid_578946 = query.getOrDefault("fields")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "fields", valid_578946
  var valid_578947 = query.getOrDefault("access_token")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "access_token", valid_578947
  var valid_578948 = query.getOrDefault("upload_protocol")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "upload_protocol", valid_578948
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578949: Call_CloudresourcemanagerProjectsList_578932;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Projects that the caller has the `resourcemanager.projects.get`
  ## permission on and satisfy the specified filter.
  ## 
  ## This method returns Projects in an unspecified order.
  ## This method is eventually consistent with project mutations; this means
  ## that a newly created project may not appear in the results or recent
  ## updates to an existing project may not be reflected in the results. To
  ## retrieve the latest state of a project, use the
  ## GetProject method.
  ## 
  ## NOTE: If the request filter contains a `parent.type` and `parent.id` and
  ## the caller has the `resourcemanager.projects.list` permission on the
  ## parent, the results will be drawn from an alternate index which provides
  ## more consistent results. In future versions of this API, this List method
  ## will be split into List and Search to properly capture the behavorial
  ## difference.
  ## 
  let valid = call_578949.validator(path, query, header, formData, body)
  let scheme = call_578949.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578949.url(scheme.get, call_578949.host, call_578949.base,
                         call_578949.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578949, url, valid)

proc call*(call_578950: Call_CloudresourcemanagerProjectsList_578932;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerProjectsList
  ## Lists Projects that the caller has the `resourcemanager.projects.get`
  ## permission on and satisfy the specified filter.
  ## 
  ## This method returns Projects in an unspecified order.
  ## This method is eventually consistent with project mutations; this means
  ## that a newly created project may not appear in the results or recent
  ## updates to an existing project may not be reflected in the results. To
  ## retrieve the latest state of a project, use the
  ## GetProject method.
  ## 
  ## NOTE: If the request filter contains a `parent.type` and `parent.id` and
  ## the caller has the `resourcemanager.projects.list` permission on the
  ## parent, the results will be drawn from an alternate index which provides
  ## more consistent results. In future versions of this API, this List method
  ## will be split into List and Search to properly capture the behavorial
  ## difference.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of Projects to return in the response.
  ## The server can return fewer Projects than requested.
  ## If unspecified, server picks an appropriate default.
  ## 
  ## Optional.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : An expression for filtering the results of the request.  Filter rules are
  ## case insensitive. The fields eligible for filtering are:
  ## 
  ## + `name`
  ## + `id`
  ## + `labels.<key>` (where *key* is the name of a label)
  ## + `parent.type`
  ## + `parent.id`
  ## 
  ## Some examples of using labels as filters:
  ## 
  ## | Filter           | Description                                         |
  ## |------------------|-----------------------------------------------------|
  ## | name:how*        | The project's name starts with "how".               |
  ## | name:Howl        | The project's name is `Howl` or `howl`.             |
  ## | name:HOWL        | Equivalent to above.                                |
  ## | NAME:howl        | Equivalent to above.                                |
  ## | labels.color:*   | The project has the label `color`.                  |
  ## | labels.color:red | The project's label `color` has the value `red`.    |
  ## | labels.color:red&nbsp;labels.size:big |The project's label `color` has
  ##   the value `red` and its label `size` has the value `big`.              |
  ## 
  ## If no filter is specified, the call will return projects for which the user
  ## has the `resourcemanager.projects.get` permission.
  ## 
  ## NOTE: To perform a by-parent query (eg., what projects are directly in a
  ## Folder), the caller must have the `resourcemanager.projects.list`
  ## permission on the parent and the filter must contain both a `parent.type`
  ## and a `parent.id` restriction
  ## (example: "parent.type:folder parent.id:123"). In this case an alternate
  ## search index is used which provides more consistent results.
  ## 
  ## Optional.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to ListProjects
  ## that indicates from where listing should continue.
  ## 
  ## Optional.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578951 = newJObject()
  add(query_578951, "key", newJString(key))
  add(query_578951, "prettyPrint", newJBool(prettyPrint))
  add(query_578951, "oauth_token", newJString(oauthToken))
  add(query_578951, "$.xgafv", newJString(Xgafv))
  add(query_578951, "pageSize", newJInt(pageSize))
  add(query_578951, "alt", newJString(alt))
  add(query_578951, "uploadType", newJString(uploadType))
  add(query_578951, "quotaUser", newJString(quotaUser))
  add(query_578951, "filter", newJString(filter))
  add(query_578951, "pageToken", newJString(pageToken))
  add(query_578951, "callback", newJString(callback))
  add(query_578951, "fields", newJString(fields))
  add(query_578951, "access_token", newJString(accessToken))
  add(query_578951, "upload_protocol", newJString(uploadProtocol))
  result = call_578950.call(nil, query_578951, nil, nil, nil)

var cloudresourcemanagerProjectsList* = Call_CloudresourcemanagerProjectsList_578932(
    name: "cloudresourcemanagerProjectsList", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/projects",
    validator: validate_CloudresourcemanagerProjectsList_578933, base: "/",
    url: url_CloudresourcemanagerProjectsList_578934, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsUpdate_579004 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerProjectsUpdate_579006(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsUpdate_579005(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the attributes of the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The project ID (for example, `my-project-123`).
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579007 = path.getOrDefault("projectId")
  valid_579007 = validateParameter(valid_579007, JString, required = true,
                                 default = nil)
  if valid_579007 != nil:
    section.add "projectId", valid_579007
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
  var valid_579008 = query.getOrDefault("key")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "key", valid_579008
  var valid_579009 = query.getOrDefault("prettyPrint")
  valid_579009 = validateParameter(valid_579009, JBool, required = false,
                                 default = newJBool(true))
  if valid_579009 != nil:
    section.add "prettyPrint", valid_579009
  var valid_579010 = query.getOrDefault("oauth_token")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "oauth_token", valid_579010
  var valid_579011 = query.getOrDefault("$.xgafv")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = newJString("1"))
  if valid_579011 != nil:
    section.add "$.xgafv", valid_579011
  var valid_579012 = query.getOrDefault("alt")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = newJString("json"))
  if valid_579012 != nil:
    section.add "alt", valid_579012
  var valid_579013 = query.getOrDefault("uploadType")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "uploadType", valid_579013
  var valid_579014 = query.getOrDefault("quotaUser")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "quotaUser", valid_579014
  var valid_579015 = query.getOrDefault("callback")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "callback", valid_579015
  var valid_579016 = query.getOrDefault("fields")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "fields", valid_579016
  var valid_579017 = query.getOrDefault("access_token")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "access_token", valid_579017
  var valid_579018 = query.getOrDefault("upload_protocol")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "upload_protocol", valid_579018
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

proc call*(call_579020: Call_CloudresourcemanagerProjectsUpdate_579004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the attributes of the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  let valid = call_579020.validator(path, query, header, formData, body)
  let scheme = call_579020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579020.url(scheme.get, call_579020.host, call_579020.base,
                         call_579020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579020, url, valid)

proc call*(call_579021: Call_CloudresourcemanagerProjectsUpdate_579004;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerProjectsUpdate
  ## Updates the attributes of the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have modify permissions for this Project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The project ID (for example, `my-project-123`).
  ## 
  ## Required.
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
  var path_579022 = newJObject()
  var query_579023 = newJObject()
  var body_579024 = newJObject()
  add(query_579023, "key", newJString(key))
  add(query_579023, "prettyPrint", newJBool(prettyPrint))
  add(query_579023, "oauth_token", newJString(oauthToken))
  add(path_579022, "projectId", newJString(projectId))
  add(query_579023, "$.xgafv", newJString(Xgafv))
  add(query_579023, "alt", newJString(alt))
  add(query_579023, "uploadType", newJString(uploadType))
  add(query_579023, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579024 = body
  add(query_579023, "callback", newJString(callback))
  add(query_579023, "fields", newJString(fields))
  add(query_579023, "access_token", newJString(accessToken))
  add(query_579023, "upload_protocol", newJString(uploadProtocol))
  result = call_579021.call(path_579022, query_579023, nil, nil, body_579024)

var cloudresourcemanagerProjectsUpdate* = Call_CloudresourcemanagerProjectsUpdate_579004(
    name: "cloudresourcemanagerProjectsUpdate", meth: HttpMethod.HttpPut,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{projectId}",
    validator: validate_CloudresourcemanagerProjectsUpdate_579005, base: "/",
    url: url_CloudresourcemanagerProjectsUpdate_579006, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsGet_578971 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerProjectsGet_578973(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsGet_578972(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Project ID (for example, `my-project-123`).
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578988 = path.getOrDefault("projectId")
  valid_578988 = validateParameter(valid_578988, JString, required = true,
                                 default = nil)
  if valid_578988 != nil:
    section.add "projectId", valid_578988
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
  var valid_578989 = query.getOrDefault("key")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "key", valid_578989
  var valid_578990 = query.getOrDefault("prettyPrint")
  valid_578990 = validateParameter(valid_578990, JBool, required = false,
                                 default = newJBool(true))
  if valid_578990 != nil:
    section.add "prettyPrint", valid_578990
  var valid_578991 = query.getOrDefault("oauth_token")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "oauth_token", valid_578991
  var valid_578992 = query.getOrDefault("$.xgafv")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = newJString("1"))
  if valid_578992 != nil:
    section.add "$.xgafv", valid_578992
  var valid_578993 = query.getOrDefault("alt")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = newJString("json"))
  if valid_578993 != nil:
    section.add "alt", valid_578993
  var valid_578994 = query.getOrDefault("uploadType")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "uploadType", valid_578994
  var valid_578995 = query.getOrDefault("quotaUser")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "quotaUser", valid_578995
  var valid_578996 = query.getOrDefault("callback")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "callback", valid_578996
  var valid_578997 = query.getOrDefault("fields")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "fields", valid_578997
  var valid_578998 = query.getOrDefault("access_token")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "access_token", valid_578998
  var valid_578999 = query.getOrDefault("upload_protocol")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "upload_protocol", valid_578999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579000: Call_CloudresourcemanagerProjectsGet_578971;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
  ## 
  let valid = call_579000.validator(path, query, header, formData, body)
  let scheme = call_579000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579000.url(scheme.get, call_579000.host, call_579000.base,
                         call_579000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579000, url, valid)

proc call*(call_579001: Call_CloudresourcemanagerProjectsGet_578971;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerProjectsGet
  ## Retrieves the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Project ID (for example, `my-project-123`).
  ## 
  ## Required.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579002 = newJObject()
  var query_579003 = newJObject()
  add(query_579003, "key", newJString(key))
  add(query_579003, "prettyPrint", newJBool(prettyPrint))
  add(query_579003, "oauth_token", newJString(oauthToken))
  add(path_579002, "projectId", newJString(projectId))
  add(query_579003, "$.xgafv", newJString(Xgafv))
  add(query_579003, "alt", newJString(alt))
  add(query_579003, "uploadType", newJString(uploadType))
  add(query_579003, "quotaUser", newJString(quotaUser))
  add(query_579003, "callback", newJString(callback))
  add(query_579003, "fields", newJString(fields))
  add(query_579003, "access_token", newJString(accessToken))
  add(query_579003, "upload_protocol", newJString(uploadProtocol))
  result = call_579001.call(path_579002, query_579003, nil, nil, nil)

var cloudresourcemanagerProjectsGet* = Call_CloudresourcemanagerProjectsGet_578971(
    name: "cloudresourcemanagerProjectsGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{projectId}",
    validator: validate_CloudresourcemanagerProjectsGet_578972, base: "/",
    url: url_CloudresourcemanagerProjectsGet_578973, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsDelete_579025 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerProjectsDelete_579027(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsDelete_579026(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Marks the Project identified by the specified
  ## `project_id` (for example, `my-project-123`) for deletion.
  ## This method will only affect the Project if it has a lifecycle state of
  ## ACTIVE.
  ## 
  ## This method changes the Project's lifecycle state from
  ## ACTIVE
  ## to DELETE_REQUESTED.
  ## The deletion starts at an unspecified time,
  ## at which point the Project is no longer accessible.
  ## 
  ## Until the deletion completes, you can check the lifecycle state
  ## checked by retrieving the Project with GetProject,
  ## and the Project remains visible to ListProjects.
  ## However, you cannot update the project.
  ## 
  ## After the deletion completes, the Project is not retrievable by
  ## the  GetProject and
  ## ListProjects methods.
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Project ID (for example, `foo-bar-123`).
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579028 = path.getOrDefault("projectId")
  valid_579028 = validateParameter(valid_579028, JString, required = true,
                                 default = nil)
  if valid_579028 != nil:
    section.add "projectId", valid_579028
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
  var valid_579029 = query.getOrDefault("key")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "key", valid_579029
  var valid_579030 = query.getOrDefault("prettyPrint")
  valid_579030 = validateParameter(valid_579030, JBool, required = false,
                                 default = newJBool(true))
  if valid_579030 != nil:
    section.add "prettyPrint", valid_579030
  var valid_579031 = query.getOrDefault("oauth_token")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "oauth_token", valid_579031
  var valid_579032 = query.getOrDefault("$.xgafv")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = newJString("1"))
  if valid_579032 != nil:
    section.add "$.xgafv", valid_579032
  var valid_579033 = query.getOrDefault("alt")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = newJString("json"))
  if valid_579033 != nil:
    section.add "alt", valid_579033
  var valid_579034 = query.getOrDefault("uploadType")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "uploadType", valid_579034
  var valid_579035 = query.getOrDefault("quotaUser")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "quotaUser", valid_579035
  var valid_579036 = query.getOrDefault("callback")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "callback", valid_579036
  var valid_579037 = query.getOrDefault("fields")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "fields", valid_579037
  var valid_579038 = query.getOrDefault("access_token")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "access_token", valid_579038
  var valid_579039 = query.getOrDefault("upload_protocol")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "upload_protocol", valid_579039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579040: Call_CloudresourcemanagerProjectsDelete_579025;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Marks the Project identified by the specified
  ## `project_id` (for example, `my-project-123`) for deletion.
  ## This method will only affect the Project if it has a lifecycle state of
  ## ACTIVE.
  ## 
  ## This method changes the Project's lifecycle state from
  ## ACTIVE
  ## to DELETE_REQUESTED.
  ## The deletion starts at an unspecified time,
  ## at which point the Project is no longer accessible.
  ## 
  ## Until the deletion completes, you can check the lifecycle state
  ## checked by retrieving the Project with GetProject,
  ## and the Project remains visible to ListProjects.
  ## However, you cannot update the project.
  ## 
  ## After the deletion completes, the Project is not retrievable by
  ## the  GetProject and
  ## ListProjects methods.
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  let valid = call_579040.validator(path, query, header, formData, body)
  let scheme = call_579040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579040.url(scheme.get, call_579040.host, call_579040.base,
                         call_579040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579040, url, valid)

proc call*(call_579041: Call_CloudresourcemanagerProjectsDelete_579025;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerProjectsDelete
  ## Marks the Project identified by the specified
  ## `project_id` (for example, `my-project-123`) for deletion.
  ## This method will only affect the Project if it has a lifecycle state of
  ## ACTIVE.
  ## 
  ## This method changes the Project's lifecycle state from
  ## ACTIVE
  ## to DELETE_REQUESTED.
  ## The deletion starts at an unspecified time,
  ## at which point the Project is no longer accessible.
  ## 
  ## Until the deletion completes, you can check the lifecycle state
  ## checked by retrieving the Project with GetProject,
  ## and the Project remains visible to ListProjects.
  ## However, you cannot update the project.
  ## 
  ## After the deletion completes, the Project is not retrievable by
  ## the  GetProject and
  ## ListProjects methods.
  ## 
  ## The caller must have modify permissions for this Project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Project ID (for example, `foo-bar-123`).
  ## 
  ## Required.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579042 = newJObject()
  var query_579043 = newJObject()
  add(query_579043, "key", newJString(key))
  add(query_579043, "prettyPrint", newJBool(prettyPrint))
  add(query_579043, "oauth_token", newJString(oauthToken))
  add(path_579042, "projectId", newJString(projectId))
  add(query_579043, "$.xgafv", newJString(Xgafv))
  add(query_579043, "alt", newJString(alt))
  add(query_579043, "uploadType", newJString(uploadType))
  add(query_579043, "quotaUser", newJString(quotaUser))
  add(query_579043, "callback", newJString(callback))
  add(query_579043, "fields", newJString(fields))
  add(query_579043, "access_token", newJString(accessToken))
  add(query_579043, "upload_protocol", newJString(uploadProtocol))
  result = call_579041.call(path_579042, query_579043, nil, nil, nil)

var cloudresourcemanagerProjectsDelete* = Call_CloudresourcemanagerProjectsDelete_579025(
    name: "cloudresourcemanagerProjectsDelete", meth: HttpMethod.HttpDelete,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{projectId}",
    validator: validate_CloudresourcemanagerProjectsDelete_579026, base: "/",
    url: url_CloudresourcemanagerProjectsDelete_579027, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsGetAncestry_579044 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerProjectsGetAncestry_579046(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: ":getAncestry")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsGetAncestry_579045(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of ancestors in the resource hierarchy for the Project
  ## identified by the specified `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Project ID (for example, `my-project-123`).
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579047 = path.getOrDefault("projectId")
  valid_579047 = validateParameter(valid_579047, JString, required = true,
                                 default = nil)
  if valid_579047 != nil:
    section.add "projectId", valid_579047
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
  var valid_579048 = query.getOrDefault("key")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "key", valid_579048
  var valid_579049 = query.getOrDefault("prettyPrint")
  valid_579049 = validateParameter(valid_579049, JBool, required = false,
                                 default = newJBool(true))
  if valid_579049 != nil:
    section.add "prettyPrint", valid_579049
  var valid_579050 = query.getOrDefault("oauth_token")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "oauth_token", valid_579050
  var valid_579051 = query.getOrDefault("$.xgafv")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = newJString("1"))
  if valid_579051 != nil:
    section.add "$.xgafv", valid_579051
  var valid_579052 = query.getOrDefault("alt")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = newJString("json"))
  if valid_579052 != nil:
    section.add "alt", valid_579052
  var valid_579053 = query.getOrDefault("uploadType")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "uploadType", valid_579053
  var valid_579054 = query.getOrDefault("quotaUser")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "quotaUser", valid_579054
  var valid_579055 = query.getOrDefault("callback")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "callback", valid_579055
  var valid_579056 = query.getOrDefault("fields")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "fields", valid_579056
  var valid_579057 = query.getOrDefault("access_token")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "access_token", valid_579057
  var valid_579058 = query.getOrDefault("upload_protocol")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "upload_protocol", valid_579058
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

proc call*(call_579060: Call_CloudresourcemanagerProjectsGetAncestry_579044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of ancestors in the resource hierarchy for the Project
  ## identified by the specified `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
  ## 
  let valid = call_579060.validator(path, query, header, formData, body)
  let scheme = call_579060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579060.url(scheme.get, call_579060.host, call_579060.base,
                         call_579060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579060, url, valid)

proc call*(call_579061: Call_CloudresourcemanagerProjectsGetAncestry_579044;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerProjectsGetAncestry
  ## Gets a list of ancestors in the resource hierarchy for the Project
  ## identified by the specified `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Project ID (for example, `my-project-123`).
  ## 
  ## Required.
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
  var path_579062 = newJObject()
  var query_579063 = newJObject()
  var body_579064 = newJObject()
  add(query_579063, "key", newJString(key))
  add(query_579063, "prettyPrint", newJBool(prettyPrint))
  add(query_579063, "oauth_token", newJString(oauthToken))
  add(path_579062, "projectId", newJString(projectId))
  add(query_579063, "$.xgafv", newJString(Xgafv))
  add(query_579063, "alt", newJString(alt))
  add(query_579063, "uploadType", newJString(uploadType))
  add(query_579063, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579064 = body
  add(query_579063, "callback", newJString(callback))
  add(query_579063, "fields", newJString(fields))
  add(query_579063, "access_token", newJString(accessToken))
  add(query_579063, "upload_protocol", newJString(uploadProtocol))
  result = call_579061.call(path_579062, query_579063, nil, nil, body_579064)

var cloudresourcemanagerProjectsGetAncestry* = Call_CloudresourcemanagerProjectsGetAncestry_579044(
    name: "cloudresourcemanagerProjectsGetAncestry", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{projectId}:getAncestry",
    validator: validate_CloudresourcemanagerProjectsGetAncestry_579045, base: "/",
    url: url_CloudresourcemanagerProjectsGetAncestry_579046,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsUndelete_579065 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerProjectsUndelete_579067(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: ":undelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsUndelete_579066(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restores the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## You can only use this method for a Project that has a lifecycle state of
  ## DELETE_REQUESTED.
  ## After deletion starts, the Project cannot be restored.
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The project ID (for example, `foo-bar-123`).
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579068 = path.getOrDefault("projectId")
  valid_579068 = validateParameter(valid_579068, JString, required = true,
                                 default = nil)
  if valid_579068 != nil:
    section.add "projectId", valid_579068
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
  var valid_579069 = query.getOrDefault("key")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "key", valid_579069
  var valid_579070 = query.getOrDefault("prettyPrint")
  valid_579070 = validateParameter(valid_579070, JBool, required = false,
                                 default = newJBool(true))
  if valid_579070 != nil:
    section.add "prettyPrint", valid_579070
  var valid_579071 = query.getOrDefault("oauth_token")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "oauth_token", valid_579071
  var valid_579072 = query.getOrDefault("$.xgafv")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = newJString("1"))
  if valid_579072 != nil:
    section.add "$.xgafv", valid_579072
  var valid_579073 = query.getOrDefault("alt")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = newJString("json"))
  if valid_579073 != nil:
    section.add "alt", valid_579073
  var valid_579074 = query.getOrDefault("uploadType")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "uploadType", valid_579074
  var valid_579075 = query.getOrDefault("quotaUser")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "quotaUser", valid_579075
  var valid_579076 = query.getOrDefault("callback")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "callback", valid_579076
  var valid_579077 = query.getOrDefault("fields")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "fields", valid_579077
  var valid_579078 = query.getOrDefault("access_token")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "access_token", valid_579078
  var valid_579079 = query.getOrDefault("upload_protocol")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "upload_protocol", valid_579079
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

proc call*(call_579081: Call_CloudresourcemanagerProjectsUndelete_579065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Restores the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## You can only use this method for a Project that has a lifecycle state of
  ## DELETE_REQUESTED.
  ## After deletion starts, the Project cannot be restored.
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  let valid = call_579081.validator(path, query, header, formData, body)
  let scheme = call_579081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579081.url(scheme.get, call_579081.host, call_579081.base,
                         call_579081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579081, url, valid)

proc call*(call_579082: Call_CloudresourcemanagerProjectsUndelete_579065;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerProjectsUndelete
  ## Restores the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## You can only use this method for a Project that has a lifecycle state of
  ## DELETE_REQUESTED.
  ## After deletion starts, the Project cannot be restored.
  ## 
  ## The caller must have modify permissions for this Project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The project ID (for example, `foo-bar-123`).
  ## 
  ## Required.
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
  var path_579083 = newJObject()
  var query_579084 = newJObject()
  var body_579085 = newJObject()
  add(query_579084, "key", newJString(key))
  add(query_579084, "prettyPrint", newJBool(prettyPrint))
  add(query_579084, "oauth_token", newJString(oauthToken))
  add(path_579083, "projectId", newJString(projectId))
  add(query_579084, "$.xgafv", newJString(Xgafv))
  add(query_579084, "alt", newJString(alt))
  add(query_579084, "uploadType", newJString(uploadType))
  add(query_579084, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579085 = body
  add(query_579084, "callback", newJString(callback))
  add(query_579084, "fields", newJString(fields))
  add(query_579084, "access_token", newJString(accessToken))
  add(query_579084, "upload_protocol", newJString(uploadProtocol))
  result = call_579082.call(path_579083, query_579084, nil, nil, body_579085)

var cloudresourcemanagerProjectsUndelete* = Call_CloudresourcemanagerProjectsUndelete_579065(
    name: "cloudresourcemanagerProjectsUndelete", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{projectId}:undelete",
    validator: validate_CloudresourcemanagerProjectsUndelete_579066, base: "/",
    url: url_CloudresourcemanagerProjectsUndelete_579067, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsGetIamPolicy_579086 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerProjectsGetIamPolicy_579088(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsGetIamPolicy_579087(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the IAM access control policy for the specified Project.
  ## Permission is denied if the policy or the resource does not exist.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.getIamPolicy` on the project.
  ## 
  ## For additional information about resource structure and identification,
  ## see [Resource Names](/apis/design/resource_names).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579089 = path.getOrDefault("resource")
  valid_579089 = validateParameter(valid_579089, JString, required = true,
                                 default = nil)
  if valid_579089 != nil:
    section.add "resource", valid_579089
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
  var valid_579090 = query.getOrDefault("key")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "key", valid_579090
  var valid_579091 = query.getOrDefault("prettyPrint")
  valid_579091 = validateParameter(valid_579091, JBool, required = false,
                                 default = newJBool(true))
  if valid_579091 != nil:
    section.add "prettyPrint", valid_579091
  var valid_579092 = query.getOrDefault("oauth_token")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "oauth_token", valid_579092
  var valid_579093 = query.getOrDefault("$.xgafv")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = newJString("1"))
  if valid_579093 != nil:
    section.add "$.xgafv", valid_579093
  var valid_579094 = query.getOrDefault("alt")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = newJString("json"))
  if valid_579094 != nil:
    section.add "alt", valid_579094
  var valid_579095 = query.getOrDefault("uploadType")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "uploadType", valid_579095
  var valid_579096 = query.getOrDefault("quotaUser")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "quotaUser", valid_579096
  var valid_579097 = query.getOrDefault("callback")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "callback", valid_579097
  var valid_579098 = query.getOrDefault("fields")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "fields", valid_579098
  var valid_579099 = query.getOrDefault("access_token")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "access_token", valid_579099
  var valid_579100 = query.getOrDefault("upload_protocol")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "upload_protocol", valid_579100
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

proc call*(call_579102: Call_CloudresourcemanagerProjectsGetIamPolicy_579086;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the IAM access control policy for the specified Project.
  ## Permission is denied if the policy or the resource does not exist.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.getIamPolicy` on the project.
  ## 
  ## For additional information about resource structure and identification,
  ## see [Resource Names](/apis/design/resource_names).
  ## 
  let valid = call_579102.validator(path, query, header, formData, body)
  let scheme = call_579102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579102.url(scheme.get, call_579102.host, call_579102.base,
                         call_579102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579102, url, valid)

proc call*(call_579103: Call_CloudresourcemanagerProjectsGetIamPolicy_579086;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerProjectsGetIamPolicy
  ## Returns the IAM access control policy for the specified Project.
  ## Permission is denied if the policy or the resource does not exist.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.getIamPolicy` on the project.
  ## 
  ## For additional information about resource structure and identification,
  ## see [Resource Names](/apis/design/resource_names).
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579104 = newJObject()
  var query_579105 = newJObject()
  var body_579106 = newJObject()
  add(query_579105, "key", newJString(key))
  add(query_579105, "prettyPrint", newJBool(prettyPrint))
  add(query_579105, "oauth_token", newJString(oauthToken))
  add(query_579105, "$.xgafv", newJString(Xgafv))
  add(query_579105, "alt", newJString(alt))
  add(query_579105, "uploadType", newJString(uploadType))
  add(query_579105, "quotaUser", newJString(quotaUser))
  add(path_579104, "resource", newJString(resource))
  if body != nil:
    body_579106 = body
  add(query_579105, "callback", newJString(callback))
  add(query_579105, "fields", newJString(fields))
  add(query_579105, "access_token", newJString(accessToken))
  add(query_579105, "upload_protocol", newJString(uploadProtocol))
  result = call_579103.call(path_579104, query_579105, nil, nil, body_579106)

var cloudresourcemanagerProjectsGetIamPolicy* = Call_CloudresourcemanagerProjectsGetIamPolicy_579086(
    name: "cloudresourcemanagerProjectsGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{resource}:getIamPolicy",
    validator: validate_CloudresourcemanagerProjectsGetIamPolicy_579087,
    base: "/", url: url_CloudresourcemanagerProjectsGetIamPolicy_579088,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsSetIamPolicy_579107 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerProjectsSetIamPolicy_579109(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsSetIamPolicy_579108(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the IAM access control policy for the specified Project. Overwrites
  ## any existing policy.
  ## 
  ## The following constraints apply when using `setIamPolicy()`:
  ## 
  ## + Project does not support `allUsers` and `allAuthenticatedUsers` as
  ## `members` in a `Binding` of a `Policy`.
  ## 
  ## + The owner role can be granted to a `user`, `serviceAccount`, or a group
  ## that is part of an organization. For example,
  ## group@myownpersonaldomain.com could be added as an owner to a project in
  ## the myownpersonaldomain.com organization, but not the examplepetstore.com
  ## organization.
  ## 
  ## + Service accounts can be made owners of a project directly
  ## without any restrictions. However, to be added as an owner, a user must be
  ## invited via Cloud Platform console and must accept the invitation.
  ## 
  ## + A user cannot be granted the owner role using `setIamPolicy()`. The user
  ## must be granted the owner role using the Cloud Platform Console and must
  ## explicitly accept the invitation.
  ## 
  ## + You can only grant ownership of a project to a member by using the
  ## GCP Console. Inviting a member will deliver an invitation email that
  ## they must accept. An invitation email is not generated if you are
  ## granting a role other than owner, or if both the member you are inviting
  ## and the project are part of your organization.
  ## 
  ## + Membership changes that leave the project without any owners that have
  ## accepted the Terms of Service (ToS) will be rejected.
  ## 
  ## + If the project is not part of an organization, there must be at least
  ## one owner who has accepted the Terms of Service (ToS) agreement in the
  ## policy. Calling `setIamPolicy()` to remove the last ToS-accepted owner
  ## from the policy will fail. This restriction also applies to legacy
  ## projects that no longer have owners who have accepted the ToS. Edits to
  ## IAM policies will be rejected until the lack of a ToS-accepting owner is
  ## rectified.
  ## 
  ## + This method will replace the existing policy, and cannot be used to
  ## append additional IAM settings.
  ## 
  ## Note: Removing service accounts from policies or changing their roles
  ## can render services completely inoperable. It is important to understand
  ## how the service account is being used before removing or updating its
  ## roles.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.setIamPolicy` on the project
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579110 = path.getOrDefault("resource")
  valid_579110 = validateParameter(valid_579110, JString, required = true,
                                 default = nil)
  if valid_579110 != nil:
    section.add "resource", valid_579110
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
  var valid_579111 = query.getOrDefault("key")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "key", valid_579111
  var valid_579112 = query.getOrDefault("prettyPrint")
  valid_579112 = validateParameter(valid_579112, JBool, required = false,
                                 default = newJBool(true))
  if valid_579112 != nil:
    section.add "prettyPrint", valid_579112
  var valid_579113 = query.getOrDefault("oauth_token")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "oauth_token", valid_579113
  var valid_579114 = query.getOrDefault("$.xgafv")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = newJString("1"))
  if valid_579114 != nil:
    section.add "$.xgafv", valid_579114
  var valid_579115 = query.getOrDefault("alt")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = newJString("json"))
  if valid_579115 != nil:
    section.add "alt", valid_579115
  var valid_579116 = query.getOrDefault("uploadType")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "uploadType", valid_579116
  var valid_579117 = query.getOrDefault("quotaUser")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "quotaUser", valid_579117
  var valid_579118 = query.getOrDefault("callback")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "callback", valid_579118
  var valid_579119 = query.getOrDefault("fields")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "fields", valid_579119
  var valid_579120 = query.getOrDefault("access_token")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "access_token", valid_579120
  var valid_579121 = query.getOrDefault("upload_protocol")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "upload_protocol", valid_579121
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

proc call*(call_579123: Call_CloudresourcemanagerProjectsSetIamPolicy_579107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the IAM access control policy for the specified Project. Overwrites
  ## any existing policy.
  ## 
  ## The following constraints apply when using `setIamPolicy()`:
  ## 
  ## + Project does not support `allUsers` and `allAuthenticatedUsers` as
  ## `members` in a `Binding` of a `Policy`.
  ## 
  ## + The owner role can be granted to a `user`, `serviceAccount`, or a group
  ## that is part of an organization. For example,
  ## group@myownpersonaldomain.com could be added as an owner to a project in
  ## the myownpersonaldomain.com organization, but not the examplepetstore.com
  ## organization.
  ## 
  ## + Service accounts can be made owners of a project directly
  ## without any restrictions. However, to be added as an owner, a user must be
  ## invited via Cloud Platform console and must accept the invitation.
  ## 
  ## + A user cannot be granted the owner role using `setIamPolicy()`. The user
  ## must be granted the owner role using the Cloud Platform Console and must
  ## explicitly accept the invitation.
  ## 
  ## + You can only grant ownership of a project to a member by using the
  ## GCP Console. Inviting a member will deliver an invitation email that
  ## they must accept. An invitation email is not generated if you are
  ## granting a role other than owner, or if both the member you are inviting
  ## and the project are part of your organization.
  ## 
  ## + Membership changes that leave the project without any owners that have
  ## accepted the Terms of Service (ToS) will be rejected.
  ## 
  ## + If the project is not part of an organization, there must be at least
  ## one owner who has accepted the Terms of Service (ToS) agreement in the
  ## policy. Calling `setIamPolicy()` to remove the last ToS-accepted owner
  ## from the policy will fail. This restriction also applies to legacy
  ## projects that no longer have owners who have accepted the ToS. Edits to
  ## IAM policies will be rejected until the lack of a ToS-accepting owner is
  ## rectified.
  ## 
  ## + This method will replace the existing policy, and cannot be used to
  ## append additional IAM settings.
  ## 
  ## Note: Removing service accounts from policies or changing their roles
  ## can render services completely inoperable. It is important to understand
  ## how the service account is being used before removing or updating its
  ## roles.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.setIamPolicy` on the project
  ## 
  let valid = call_579123.validator(path, query, header, formData, body)
  let scheme = call_579123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579123.url(scheme.get, call_579123.host, call_579123.base,
                         call_579123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579123, url, valid)

proc call*(call_579124: Call_CloudresourcemanagerProjectsSetIamPolicy_579107;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerProjectsSetIamPolicy
  ## Sets the IAM access control policy for the specified Project. Overwrites
  ## any existing policy.
  ## 
  ## The following constraints apply when using `setIamPolicy()`:
  ## 
  ## + Project does not support `allUsers` and `allAuthenticatedUsers` as
  ## `members` in a `Binding` of a `Policy`.
  ## 
  ## + The owner role can be granted to a `user`, `serviceAccount`, or a group
  ## that is part of an organization. For example,
  ## group@myownpersonaldomain.com could be added as an owner to a project in
  ## the myownpersonaldomain.com organization, but not the examplepetstore.com
  ## organization.
  ## 
  ## + Service accounts can be made owners of a project directly
  ## without any restrictions. However, to be added as an owner, a user must be
  ## invited via Cloud Platform console and must accept the invitation.
  ## 
  ## + A user cannot be granted the owner role using `setIamPolicy()`. The user
  ## must be granted the owner role using the Cloud Platform Console and must
  ## explicitly accept the invitation.
  ## 
  ## + You can only grant ownership of a project to a member by using the
  ## GCP Console. Inviting a member will deliver an invitation email that
  ## they must accept. An invitation email is not generated if you are
  ## granting a role other than owner, or if both the member you are inviting
  ## and the project are part of your organization.
  ## 
  ## + Membership changes that leave the project without any owners that have
  ## accepted the Terms of Service (ToS) will be rejected.
  ## 
  ## + If the project is not part of an organization, there must be at least
  ## one owner who has accepted the Terms of Service (ToS) agreement in the
  ## policy. Calling `setIamPolicy()` to remove the last ToS-accepted owner
  ## from the policy will fail. This restriction also applies to legacy
  ## projects that no longer have owners who have accepted the ToS. Edits to
  ## IAM policies will be rejected until the lack of a ToS-accepting owner is
  ## rectified.
  ## 
  ## + This method will replace the existing policy, and cannot be used to
  ## append additional IAM settings.
  ## 
  ## Note: Removing service accounts from policies or changing their roles
  ## can render services completely inoperable. It is important to understand
  ## how the service account is being used before removing or updating its
  ## roles.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.setIamPolicy` on the project
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579125 = newJObject()
  var query_579126 = newJObject()
  var body_579127 = newJObject()
  add(query_579126, "key", newJString(key))
  add(query_579126, "prettyPrint", newJBool(prettyPrint))
  add(query_579126, "oauth_token", newJString(oauthToken))
  add(query_579126, "$.xgafv", newJString(Xgafv))
  add(query_579126, "alt", newJString(alt))
  add(query_579126, "uploadType", newJString(uploadType))
  add(query_579126, "quotaUser", newJString(quotaUser))
  add(path_579125, "resource", newJString(resource))
  if body != nil:
    body_579127 = body
  add(query_579126, "callback", newJString(callback))
  add(query_579126, "fields", newJString(fields))
  add(query_579126, "access_token", newJString(accessToken))
  add(query_579126, "upload_protocol", newJString(uploadProtocol))
  result = call_579124.call(path_579125, query_579126, nil, nil, body_579127)

var cloudresourcemanagerProjectsSetIamPolicy* = Call_CloudresourcemanagerProjectsSetIamPolicy_579107(
    name: "cloudresourcemanagerProjectsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{resource}:setIamPolicy",
    validator: validate_CloudresourcemanagerProjectsSetIamPolicy_579108,
    base: "/", url: url_CloudresourcemanagerProjectsSetIamPolicy_579109,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsTestIamPermissions_579128 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerProjectsTestIamPermissions_579130(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsTestIamPermissions_579129(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579131 = path.getOrDefault("resource")
  valid_579131 = validateParameter(valid_579131, JString, required = true,
                                 default = nil)
  if valid_579131 != nil:
    section.add "resource", valid_579131
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
  var valid_579132 = query.getOrDefault("key")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "key", valid_579132
  var valid_579133 = query.getOrDefault("prettyPrint")
  valid_579133 = validateParameter(valid_579133, JBool, required = false,
                                 default = newJBool(true))
  if valid_579133 != nil:
    section.add "prettyPrint", valid_579133
  var valid_579134 = query.getOrDefault("oauth_token")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "oauth_token", valid_579134
  var valid_579135 = query.getOrDefault("$.xgafv")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = newJString("1"))
  if valid_579135 != nil:
    section.add "$.xgafv", valid_579135
  var valid_579136 = query.getOrDefault("alt")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = newJString("json"))
  if valid_579136 != nil:
    section.add "alt", valid_579136
  var valid_579137 = query.getOrDefault("uploadType")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "uploadType", valid_579137
  var valid_579138 = query.getOrDefault("quotaUser")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "quotaUser", valid_579138
  var valid_579139 = query.getOrDefault("callback")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "callback", valid_579139
  var valid_579140 = query.getOrDefault("fields")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "fields", valid_579140
  var valid_579141 = query.getOrDefault("access_token")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "access_token", valid_579141
  var valid_579142 = query.getOrDefault("upload_protocol")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "upload_protocol", valid_579142
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

proc call*(call_579144: Call_CloudresourcemanagerProjectsTestIamPermissions_579128;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_579144.validator(path, query, header, formData, body)
  let scheme = call_579144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579144.url(scheme.get, call_579144.host, call_579144.base,
                         call_579144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579144, url, valid)

proc call*(call_579145: Call_CloudresourcemanagerProjectsTestIamPermissions_579128;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerProjectsTestIamPermissions
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579146 = newJObject()
  var query_579147 = newJObject()
  var body_579148 = newJObject()
  add(query_579147, "key", newJString(key))
  add(query_579147, "prettyPrint", newJBool(prettyPrint))
  add(query_579147, "oauth_token", newJString(oauthToken))
  add(query_579147, "$.xgafv", newJString(Xgafv))
  add(query_579147, "alt", newJString(alt))
  add(query_579147, "uploadType", newJString(uploadType))
  add(query_579147, "quotaUser", newJString(quotaUser))
  add(path_579146, "resource", newJString(resource))
  if body != nil:
    body_579148 = body
  add(query_579147, "callback", newJString(callback))
  add(query_579147, "fields", newJString(fields))
  add(query_579147, "access_token", newJString(accessToken))
  add(query_579147, "upload_protocol", newJString(uploadProtocol))
  result = call_579145.call(path_579146, query_579147, nil, nil, body_579148)

var cloudresourcemanagerProjectsTestIamPermissions* = Call_CloudresourcemanagerProjectsTestIamPermissions_579128(
    name: "cloudresourcemanagerProjectsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{resource}:testIamPermissions",
    validator: validate_CloudresourcemanagerProjectsTestIamPermissions_579129,
    base: "/", url: url_CloudresourcemanagerProjectsTestIamPermissions_579130,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsGet_579149 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerOrganizationsGet_579151(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsGet_579150(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches an Organization resource identified by the specified resource name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the Organization to fetch. This is the organization's
  ## relative path in the API, formatted as "organizations/[organizationId]".
  ## For example, "organizations/1234".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579152 = path.getOrDefault("name")
  valid_579152 = validateParameter(valid_579152, JString, required = true,
                                 default = nil)
  if valid_579152 != nil:
    section.add "name", valid_579152
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
  var valid_579153 = query.getOrDefault("key")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "key", valid_579153
  var valid_579154 = query.getOrDefault("prettyPrint")
  valid_579154 = validateParameter(valid_579154, JBool, required = false,
                                 default = newJBool(true))
  if valid_579154 != nil:
    section.add "prettyPrint", valid_579154
  var valid_579155 = query.getOrDefault("oauth_token")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "oauth_token", valid_579155
  var valid_579156 = query.getOrDefault("$.xgafv")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = newJString("1"))
  if valid_579156 != nil:
    section.add "$.xgafv", valid_579156
  var valid_579157 = query.getOrDefault("alt")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = newJString("json"))
  if valid_579157 != nil:
    section.add "alt", valid_579157
  var valid_579158 = query.getOrDefault("uploadType")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "uploadType", valid_579158
  var valid_579159 = query.getOrDefault("quotaUser")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "quotaUser", valid_579159
  var valid_579160 = query.getOrDefault("callback")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "callback", valid_579160
  var valid_579161 = query.getOrDefault("fields")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "fields", valid_579161
  var valid_579162 = query.getOrDefault("access_token")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "access_token", valid_579162
  var valid_579163 = query.getOrDefault("upload_protocol")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "upload_protocol", valid_579163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579164: Call_CloudresourcemanagerOrganizationsGet_579149;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches an Organization resource identified by the specified resource name.
  ## 
  let valid = call_579164.validator(path, query, header, formData, body)
  let scheme = call_579164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579164.url(scheme.get, call_579164.host, call_579164.base,
                         call_579164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579164, url, valid)

proc call*(call_579165: Call_CloudresourcemanagerOrganizationsGet_579149;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerOrganizationsGet
  ## Fetches an Organization resource identified by the specified resource name.
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
  ##       : The resource name of the Organization to fetch. This is the organization's
  ## relative path in the API, formatted as "organizations/[organizationId]".
  ## For example, "organizations/1234".
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579166 = newJObject()
  var query_579167 = newJObject()
  add(query_579167, "key", newJString(key))
  add(query_579167, "prettyPrint", newJBool(prettyPrint))
  add(query_579167, "oauth_token", newJString(oauthToken))
  add(query_579167, "$.xgafv", newJString(Xgafv))
  add(query_579167, "alt", newJString(alt))
  add(query_579167, "uploadType", newJString(uploadType))
  add(query_579167, "quotaUser", newJString(quotaUser))
  add(path_579166, "name", newJString(name))
  add(query_579167, "callback", newJString(callback))
  add(query_579167, "fields", newJString(fields))
  add(query_579167, "access_token", newJString(accessToken))
  add(query_579167, "upload_protocol", newJString(uploadProtocol))
  result = call_579165.call(path_579166, query_579167, nil, nil, nil)

var cloudresourcemanagerOrganizationsGet* = Call_CloudresourcemanagerOrganizationsGet_579149(
    name: "cloudresourcemanagerOrganizationsGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudresourcemanagerOrganizationsGet_579150, base: "/",
    url: url_CloudresourcemanagerOrganizationsGet_579151, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerLiensDelete_579168 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerLiensDelete_579170(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerLiensDelete_579169(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Lien by `name`.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, a Lien with a `parent` of `projects/1234` requires permission
  ## `resourcemanager.projects.updateLiens`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name/identifier of the Lien to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579171 = path.getOrDefault("name")
  valid_579171 = validateParameter(valid_579171, JString, required = true,
                                 default = nil)
  if valid_579171 != nil:
    section.add "name", valid_579171
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
  var valid_579172 = query.getOrDefault("key")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "key", valid_579172
  var valid_579173 = query.getOrDefault("prettyPrint")
  valid_579173 = validateParameter(valid_579173, JBool, required = false,
                                 default = newJBool(true))
  if valid_579173 != nil:
    section.add "prettyPrint", valid_579173
  var valid_579174 = query.getOrDefault("oauth_token")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "oauth_token", valid_579174
  var valid_579175 = query.getOrDefault("$.xgafv")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = newJString("1"))
  if valid_579175 != nil:
    section.add "$.xgafv", valid_579175
  var valid_579176 = query.getOrDefault("alt")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = newJString("json"))
  if valid_579176 != nil:
    section.add "alt", valid_579176
  var valid_579177 = query.getOrDefault("uploadType")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "uploadType", valid_579177
  var valid_579178 = query.getOrDefault("quotaUser")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "quotaUser", valid_579178
  var valid_579179 = query.getOrDefault("callback")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "callback", valid_579179
  var valid_579180 = query.getOrDefault("fields")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "fields", valid_579180
  var valid_579181 = query.getOrDefault("access_token")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "access_token", valid_579181
  var valid_579182 = query.getOrDefault("upload_protocol")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "upload_protocol", valid_579182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579183: Call_CloudresourcemanagerLiensDelete_579168;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a Lien by `name`.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, a Lien with a `parent` of `projects/1234` requires permission
  ## `resourcemanager.projects.updateLiens`.
  ## 
  let valid = call_579183.validator(path, query, header, formData, body)
  let scheme = call_579183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579183.url(scheme.get, call_579183.host, call_579183.base,
                         call_579183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579183, url, valid)

proc call*(call_579184: Call_CloudresourcemanagerLiensDelete_579168; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerLiensDelete
  ## Delete a Lien by `name`.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, a Lien with a `parent` of `projects/1234` requires permission
  ## `resourcemanager.projects.updateLiens`.
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
  ##       : The name/identifier of the Lien to delete.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579185 = newJObject()
  var query_579186 = newJObject()
  add(query_579186, "key", newJString(key))
  add(query_579186, "prettyPrint", newJBool(prettyPrint))
  add(query_579186, "oauth_token", newJString(oauthToken))
  add(query_579186, "$.xgafv", newJString(Xgafv))
  add(query_579186, "alt", newJString(alt))
  add(query_579186, "uploadType", newJString(uploadType))
  add(query_579186, "quotaUser", newJString(quotaUser))
  add(path_579185, "name", newJString(name))
  add(query_579186, "callback", newJString(callback))
  add(query_579186, "fields", newJString(fields))
  add(query_579186, "access_token", newJString(accessToken))
  add(query_579186, "upload_protocol", newJString(uploadProtocol))
  result = call_579184.call(path_579185, query_579186, nil, nil, nil)

var cloudresourcemanagerLiensDelete* = Call_CloudresourcemanagerLiensDelete_579168(
    name: "cloudresourcemanagerLiensDelete", meth: HttpMethod.HttpDelete,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudresourcemanagerLiensDelete_579169, base: "/",
    url: url_CloudresourcemanagerLiensDelete_579170, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsClearOrgPolicy_579187 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerOrganizationsClearOrgPolicy_579189(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":clearOrgPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsClearOrgPolicy_579188(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Clears a `Policy` from a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name of the resource for the `Policy` to clear.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579190 = path.getOrDefault("resource")
  valid_579190 = validateParameter(valid_579190, JString, required = true,
                                 default = nil)
  if valid_579190 != nil:
    section.add "resource", valid_579190
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
  var valid_579191 = query.getOrDefault("key")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "key", valid_579191
  var valid_579192 = query.getOrDefault("prettyPrint")
  valid_579192 = validateParameter(valid_579192, JBool, required = false,
                                 default = newJBool(true))
  if valid_579192 != nil:
    section.add "prettyPrint", valid_579192
  var valid_579193 = query.getOrDefault("oauth_token")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "oauth_token", valid_579193
  var valid_579194 = query.getOrDefault("$.xgafv")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = newJString("1"))
  if valid_579194 != nil:
    section.add "$.xgafv", valid_579194
  var valid_579195 = query.getOrDefault("alt")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = newJString("json"))
  if valid_579195 != nil:
    section.add "alt", valid_579195
  var valid_579196 = query.getOrDefault("uploadType")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "uploadType", valid_579196
  var valid_579197 = query.getOrDefault("quotaUser")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "quotaUser", valid_579197
  var valid_579198 = query.getOrDefault("callback")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "callback", valid_579198
  var valid_579199 = query.getOrDefault("fields")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "fields", valid_579199
  var valid_579200 = query.getOrDefault("access_token")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "access_token", valid_579200
  var valid_579201 = query.getOrDefault("upload_protocol")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "upload_protocol", valid_579201
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

proc call*(call_579203: Call_CloudresourcemanagerOrganizationsClearOrgPolicy_579187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Clears a `Policy` from a resource.
  ## 
  let valid = call_579203.validator(path, query, header, formData, body)
  let scheme = call_579203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579203.url(scheme.get, call_579203.host, call_579203.base,
                         call_579203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579203, url, valid)

proc call*(call_579204: Call_CloudresourcemanagerOrganizationsClearOrgPolicy_579187;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerOrganizationsClearOrgPolicy
  ## Clears a `Policy` from a resource.
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
  ##   resource: string (required)
  ##           : Name of the resource for the `Policy` to clear.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579205 = newJObject()
  var query_579206 = newJObject()
  var body_579207 = newJObject()
  add(query_579206, "key", newJString(key))
  add(query_579206, "prettyPrint", newJBool(prettyPrint))
  add(query_579206, "oauth_token", newJString(oauthToken))
  add(query_579206, "$.xgafv", newJString(Xgafv))
  add(query_579206, "alt", newJString(alt))
  add(query_579206, "uploadType", newJString(uploadType))
  add(query_579206, "quotaUser", newJString(quotaUser))
  add(path_579205, "resource", newJString(resource))
  if body != nil:
    body_579207 = body
  add(query_579206, "callback", newJString(callback))
  add(query_579206, "fields", newJString(fields))
  add(query_579206, "access_token", newJString(accessToken))
  add(query_579206, "upload_protocol", newJString(uploadProtocol))
  result = call_579204.call(path_579205, query_579206, nil, nil, body_579207)

var cloudresourcemanagerOrganizationsClearOrgPolicy* = Call_CloudresourcemanagerOrganizationsClearOrgPolicy_579187(
    name: "cloudresourcemanagerOrganizationsClearOrgPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:clearOrgPolicy",
    validator: validate_CloudresourcemanagerOrganizationsClearOrgPolicy_579188,
    base: "/", url: url_CloudresourcemanagerOrganizationsClearOrgPolicy_579189,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_579208 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_579210(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getEffectiveOrgPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_579209(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the effective `Policy` on a resource. This is the result of merging
  ## `Policies` in the resource hierarchy. The returned `Policy` will not have
  ## an `etag`set because it is a computed `Policy` across multiple resources.
  ## Subtrees of Resource Manager resource hierarchy with 'under:' prefix will
  ## not be expanded.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : The name of the resource to start computing the effective `Policy`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579211 = path.getOrDefault("resource")
  valid_579211 = validateParameter(valid_579211, JString, required = true,
                                 default = nil)
  if valid_579211 != nil:
    section.add "resource", valid_579211
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
  var valid_579212 = query.getOrDefault("key")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "key", valid_579212
  var valid_579213 = query.getOrDefault("prettyPrint")
  valid_579213 = validateParameter(valid_579213, JBool, required = false,
                                 default = newJBool(true))
  if valid_579213 != nil:
    section.add "prettyPrint", valid_579213
  var valid_579214 = query.getOrDefault("oauth_token")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "oauth_token", valid_579214
  var valid_579215 = query.getOrDefault("$.xgafv")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = newJString("1"))
  if valid_579215 != nil:
    section.add "$.xgafv", valid_579215
  var valid_579216 = query.getOrDefault("alt")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = newJString("json"))
  if valid_579216 != nil:
    section.add "alt", valid_579216
  var valid_579217 = query.getOrDefault("uploadType")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "uploadType", valid_579217
  var valid_579218 = query.getOrDefault("quotaUser")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "quotaUser", valid_579218
  var valid_579219 = query.getOrDefault("callback")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "callback", valid_579219
  var valid_579220 = query.getOrDefault("fields")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "fields", valid_579220
  var valid_579221 = query.getOrDefault("access_token")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "access_token", valid_579221
  var valid_579222 = query.getOrDefault("upload_protocol")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "upload_protocol", valid_579222
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

proc call*(call_579224: Call_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_579208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the effective `Policy` on a resource. This is the result of merging
  ## `Policies` in the resource hierarchy. The returned `Policy` will not have
  ## an `etag`set because it is a computed `Policy` across multiple resources.
  ## Subtrees of Resource Manager resource hierarchy with 'under:' prefix will
  ## not be expanded.
  ## 
  let valid = call_579224.validator(path, query, header, formData, body)
  let scheme = call_579224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579224.url(scheme.get, call_579224.host, call_579224.base,
                         call_579224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579224, url, valid)

proc call*(call_579225: Call_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_579208;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerOrganizationsGetEffectiveOrgPolicy
  ## Gets the effective `Policy` on a resource. This is the result of merging
  ## `Policies` in the resource hierarchy. The returned `Policy` will not have
  ## an `etag`set because it is a computed `Policy` across multiple resources.
  ## Subtrees of Resource Manager resource hierarchy with 'under:' prefix will
  ## not be expanded.
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
  ##   resource: string (required)
  ##           : The name of the resource to start computing the effective `Policy`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579226 = newJObject()
  var query_579227 = newJObject()
  var body_579228 = newJObject()
  add(query_579227, "key", newJString(key))
  add(query_579227, "prettyPrint", newJBool(prettyPrint))
  add(query_579227, "oauth_token", newJString(oauthToken))
  add(query_579227, "$.xgafv", newJString(Xgafv))
  add(query_579227, "alt", newJString(alt))
  add(query_579227, "uploadType", newJString(uploadType))
  add(query_579227, "quotaUser", newJString(quotaUser))
  add(path_579226, "resource", newJString(resource))
  if body != nil:
    body_579228 = body
  add(query_579227, "callback", newJString(callback))
  add(query_579227, "fields", newJString(fields))
  add(query_579227, "access_token", newJString(accessToken))
  add(query_579227, "upload_protocol", newJString(uploadProtocol))
  result = call_579225.call(path_579226, query_579227, nil, nil, body_579228)

var cloudresourcemanagerOrganizationsGetEffectiveOrgPolicy* = Call_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_579208(
    name: "cloudresourcemanagerOrganizationsGetEffectiveOrgPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:getEffectiveOrgPolicy",
    validator: validate_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_579209,
    base: "/", url: url_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_579210,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsGetIamPolicy_579229 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerOrganizationsGetIamPolicy_579231(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsGetIamPolicy_579230(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the access control policy for an Organization resource. May be empty
  ## if no such policy or resource exists. The `resource` field should be the
  ## organization's resource name, e.g. "organizations/123".
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.organizations.getIamPolicy` on the specified organization
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579232 = path.getOrDefault("resource")
  valid_579232 = validateParameter(valid_579232, JString, required = true,
                                 default = nil)
  if valid_579232 != nil:
    section.add "resource", valid_579232
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
  var valid_579233 = query.getOrDefault("key")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "key", valid_579233
  var valid_579234 = query.getOrDefault("prettyPrint")
  valid_579234 = validateParameter(valid_579234, JBool, required = false,
                                 default = newJBool(true))
  if valid_579234 != nil:
    section.add "prettyPrint", valid_579234
  var valid_579235 = query.getOrDefault("oauth_token")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "oauth_token", valid_579235
  var valid_579236 = query.getOrDefault("$.xgafv")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = newJString("1"))
  if valid_579236 != nil:
    section.add "$.xgafv", valid_579236
  var valid_579237 = query.getOrDefault("alt")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = newJString("json"))
  if valid_579237 != nil:
    section.add "alt", valid_579237
  var valid_579238 = query.getOrDefault("uploadType")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "uploadType", valid_579238
  var valid_579239 = query.getOrDefault("quotaUser")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "quotaUser", valid_579239
  var valid_579240 = query.getOrDefault("callback")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "callback", valid_579240
  var valid_579241 = query.getOrDefault("fields")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "fields", valid_579241
  var valid_579242 = query.getOrDefault("access_token")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "access_token", valid_579242
  var valid_579243 = query.getOrDefault("upload_protocol")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "upload_protocol", valid_579243
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

proc call*(call_579245: Call_CloudresourcemanagerOrganizationsGetIamPolicy_579229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for an Organization resource. May be empty
  ## if no such policy or resource exists. The `resource` field should be the
  ## organization's resource name, e.g. "organizations/123".
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.organizations.getIamPolicy` on the specified organization
  ## 
  let valid = call_579245.validator(path, query, header, formData, body)
  let scheme = call_579245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579245.url(scheme.get, call_579245.host, call_579245.base,
                         call_579245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579245, url, valid)

proc call*(call_579246: Call_CloudresourcemanagerOrganizationsGetIamPolicy_579229;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerOrganizationsGetIamPolicy
  ## Gets the access control policy for an Organization resource. May be empty
  ## if no such policy or resource exists. The `resource` field should be the
  ## organization's resource name, e.g. "organizations/123".
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.organizations.getIamPolicy` on the specified organization
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579247 = newJObject()
  var query_579248 = newJObject()
  var body_579249 = newJObject()
  add(query_579248, "key", newJString(key))
  add(query_579248, "prettyPrint", newJBool(prettyPrint))
  add(query_579248, "oauth_token", newJString(oauthToken))
  add(query_579248, "$.xgafv", newJString(Xgafv))
  add(query_579248, "alt", newJString(alt))
  add(query_579248, "uploadType", newJString(uploadType))
  add(query_579248, "quotaUser", newJString(quotaUser))
  add(path_579247, "resource", newJString(resource))
  if body != nil:
    body_579249 = body
  add(query_579248, "callback", newJString(callback))
  add(query_579248, "fields", newJString(fields))
  add(query_579248, "access_token", newJString(accessToken))
  add(query_579248, "upload_protocol", newJString(uploadProtocol))
  result = call_579246.call(path_579247, query_579248, nil, nil, body_579249)

var cloudresourcemanagerOrganizationsGetIamPolicy* = Call_CloudresourcemanagerOrganizationsGetIamPolicy_579229(
    name: "cloudresourcemanagerOrganizationsGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_CloudresourcemanagerOrganizationsGetIamPolicy_579230,
    base: "/", url: url_CloudresourcemanagerOrganizationsGetIamPolicy_579231,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsGetOrgPolicy_579250 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerOrganizationsGetOrgPolicy_579252(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getOrgPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsGetOrgPolicy_579251(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a `Policy` on a resource.
  ## 
  ## If no `Policy` is set on the resource, a `Policy` is returned with default
  ## values including `POLICY_TYPE_NOT_SET` for the `policy_type oneof`. The
  ## `etag` value can be used with `SetOrgPolicy()` to create or update a
  ## `Policy` during read-modify-write.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name of the resource the `Policy` is set on.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579253 = path.getOrDefault("resource")
  valid_579253 = validateParameter(valid_579253, JString, required = true,
                                 default = nil)
  if valid_579253 != nil:
    section.add "resource", valid_579253
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
  var valid_579254 = query.getOrDefault("key")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = nil)
  if valid_579254 != nil:
    section.add "key", valid_579254
  var valid_579255 = query.getOrDefault("prettyPrint")
  valid_579255 = validateParameter(valid_579255, JBool, required = false,
                                 default = newJBool(true))
  if valid_579255 != nil:
    section.add "prettyPrint", valid_579255
  var valid_579256 = query.getOrDefault("oauth_token")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "oauth_token", valid_579256
  var valid_579257 = query.getOrDefault("$.xgafv")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = newJString("1"))
  if valid_579257 != nil:
    section.add "$.xgafv", valid_579257
  var valid_579258 = query.getOrDefault("alt")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = newJString("json"))
  if valid_579258 != nil:
    section.add "alt", valid_579258
  var valid_579259 = query.getOrDefault("uploadType")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "uploadType", valid_579259
  var valid_579260 = query.getOrDefault("quotaUser")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = nil)
  if valid_579260 != nil:
    section.add "quotaUser", valid_579260
  var valid_579261 = query.getOrDefault("callback")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "callback", valid_579261
  var valid_579262 = query.getOrDefault("fields")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "fields", valid_579262
  var valid_579263 = query.getOrDefault("access_token")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = nil)
  if valid_579263 != nil:
    section.add "access_token", valid_579263
  var valid_579264 = query.getOrDefault("upload_protocol")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = nil)
  if valid_579264 != nil:
    section.add "upload_protocol", valid_579264
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

proc call*(call_579266: Call_CloudresourcemanagerOrganizationsGetOrgPolicy_579250;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a `Policy` on a resource.
  ## 
  ## If no `Policy` is set on the resource, a `Policy` is returned with default
  ## values including `POLICY_TYPE_NOT_SET` for the `policy_type oneof`. The
  ## `etag` value can be used with `SetOrgPolicy()` to create or update a
  ## `Policy` during read-modify-write.
  ## 
  let valid = call_579266.validator(path, query, header, formData, body)
  let scheme = call_579266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579266.url(scheme.get, call_579266.host, call_579266.base,
                         call_579266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579266, url, valid)

proc call*(call_579267: Call_CloudresourcemanagerOrganizationsGetOrgPolicy_579250;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerOrganizationsGetOrgPolicy
  ## Gets a `Policy` on a resource.
  ## 
  ## If no `Policy` is set on the resource, a `Policy` is returned with default
  ## values including `POLICY_TYPE_NOT_SET` for the `policy_type oneof`. The
  ## `etag` value can be used with `SetOrgPolicy()` to create or update a
  ## `Policy` during read-modify-write.
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
  ##   resource: string (required)
  ##           : Name of the resource the `Policy` is set on.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579268 = newJObject()
  var query_579269 = newJObject()
  var body_579270 = newJObject()
  add(query_579269, "key", newJString(key))
  add(query_579269, "prettyPrint", newJBool(prettyPrint))
  add(query_579269, "oauth_token", newJString(oauthToken))
  add(query_579269, "$.xgafv", newJString(Xgafv))
  add(query_579269, "alt", newJString(alt))
  add(query_579269, "uploadType", newJString(uploadType))
  add(query_579269, "quotaUser", newJString(quotaUser))
  add(path_579268, "resource", newJString(resource))
  if body != nil:
    body_579270 = body
  add(query_579269, "callback", newJString(callback))
  add(query_579269, "fields", newJString(fields))
  add(query_579269, "access_token", newJString(accessToken))
  add(query_579269, "upload_protocol", newJString(uploadProtocol))
  result = call_579267.call(path_579268, query_579269, nil, nil, body_579270)

var cloudresourcemanagerOrganizationsGetOrgPolicy* = Call_CloudresourcemanagerOrganizationsGetOrgPolicy_579250(
    name: "cloudresourcemanagerOrganizationsGetOrgPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:getOrgPolicy",
    validator: validate_CloudresourcemanagerOrganizationsGetOrgPolicy_579251,
    base: "/", url: url_CloudresourcemanagerOrganizationsGetOrgPolicy_579252,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_579271 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_579273(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"), (kind: ConstantSegment,
        value: ":listAvailableOrgPolicyConstraints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_579272(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists `Constraints` that could be applied on the specified resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name of the resource to list `Constraints` for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579274 = path.getOrDefault("resource")
  valid_579274 = validateParameter(valid_579274, JString, required = true,
                                 default = nil)
  if valid_579274 != nil:
    section.add "resource", valid_579274
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
  var valid_579275 = query.getOrDefault("key")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = nil)
  if valid_579275 != nil:
    section.add "key", valid_579275
  var valid_579276 = query.getOrDefault("prettyPrint")
  valid_579276 = validateParameter(valid_579276, JBool, required = false,
                                 default = newJBool(true))
  if valid_579276 != nil:
    section.add "prettyPrint", valid_579276
  var valid_579277 = query.getOrDefault("oauth_token")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "oauth_token", valid_579277
  var valid_579278 = query.getOrDefault("$.xgafv")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = newJString("1"))
  if valid_579278 != nil:
    section.add "$.xgafv", valid_579278
  var valid_579279 = query.getOrDefault("alt")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = newJString("json"))
  if valid_579279 != nil:
    section.add "alt", valid_579279
  var valid_579280 = query.getOrDefault("uploadType")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = nil)
  if valid_579280 != nil:
    section.add "uploadType", valid_579280
  var valid_579281 = query.getOrDefault("quotaUser")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = nil)
  if valid_579281 != nil:
    section.add "quotaUser", valid_579281
  var valid_579282 = query.getOrDefault("callback")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "callback", valid_579282
  var valid_579283 = query.getOrDefault("fields")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = nil)
  if valid_579283 != nil:
    section.add "fields", valid_579283
  var valid_579284 = query.getOrDefault("access_token")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = nil)
  if valid_579284 != nil:
    section.add "access_token", valid_579284
  var valid_579285 = query.getOrDefault("upload_protocol")
  valid_579285 = validateParameter(valid_579285, JString, required = false,
                                 default = nil)
  if valid_579285 != nil:
    section.add "upload_protocol", valid_579285
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

proc call*(call_579287: Call_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_579271;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists `Constraints` that could be applied on the specified resource.
  ## 
  let valid = call_579287.validator(path, query, header, formData, body)
  let scheme = call_579287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579287.url(scheme.get, call_579287.host, call_579287.base,
                         call_579287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579287, url, valid)

proc call*(call_579288: Call_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_579271;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints
  ## Lists `Constraints` that could be applied on the specified resource.
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
  ##   resource: string (required)
  ##           : Name of the resource to list `Constraints` for.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579289 = newJObject()
  var query_579290 = newJObject()
  var body_579291 = newJObject()
  add(query_579290, "key", newJString(key))
  add(query_579290, "prettyPrint", newJBool(prettyPrint))
  add(query_579290, "oauth_token", newJString(oauthToken))
  add(query_579290, "$.xgafv", newJString(Xgafv))
  add(query_579290, "alt", newJString(alt))
  add(query_579290, "uploadType", newJString(uploadType))
  add(query_579290, "quotaUser", newJString(quotaUser))
  add(path_579289, "resource", newJString(resource))
  if body != nil:
    body_579291 = body
  add(query_579290, "callback", newJString(callback))
  add(query_579290, "fields", newJString(fields))
  add(query_579290, "access_token", newJString(accessToken))
  add(query_579290, "upload_protocol", newJString(uploadProtocol))
  result = call_579288.call(path_579289, query_579290, nil, nil, body_579291)

var cloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints* = Call_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_579271(
    name: "cloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:listAvailableOrgPolicyConstraints", validator: validate_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_579272,
    base: "/", url: url_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_579273,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsListOrgPolicies_579292 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerOrganizationsListOrgPolicies_579294(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":listOrgPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsListOrgPolicies_579293(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the `Policies` set for a particular resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name of the resource to list Policies for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579295 = path.getOrDefault("resource")
  valid_579295 = validateParameter(valid_579295, JString, required = true,
                                 default = nil)
  if valid_579295 != nil:
    section.add "resource", valid_579295
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
  var valid_579296 = query.getOrDefault("key")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "key", valid_579296
  var valid_579297 = query.getOrDefault("prettyPrint")
  valid_579297 = validateParameter(valid_579297, JBool, required = false,
                                 default = newJBool(true))
  if valid_579297 != nil:
    section.add "prettyPrint", valid_579297
  var valid_579298 = query.getOrDefault("oauth_token")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "oauth_token", valid_579298
  var valid_579299 = query.getOrDefault("$.xgafv")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = newJString("1"))
  if valid_579299 != nil:
    section.add "$.xgafv", valid_579299
  var valid_579300 = query.getOrDefault("alt")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = newJString("json"))
  if valid_579300 != nil:
    section.add "alt", valid_579300
  var valid_579301 = query.getOrDefault("uploadType")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "uploadType", valid_579301
  var valid_579302 = query.getOrDefault("quotaUser")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = nil)
  if valid_579302 != nil:
    section.add "quotaUser", valid_579302
  var valid_579303 = query.getOrDefault("callback")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = nil)
  if valid_579303 != nil:
    section.add "callback", valid_579303
  var valid_579304 = query.getOrDefault("fields")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "fields", valid_579304
  var valid_579305 = query.getOrDefault("access_token")
  valid_579305 = validateParameter(valid_579305, JString, required = false,
                                 default = nil)
  if valid_579305 != nil:
    section.add "access_token", valid_579305
  var valid_579306 = query.getOrDefault("upload_protocol")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = nil)
  if valid_579306 != nil:
    section.add "upload_protocol", valid_579306
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

proc call*(call_579308: Call_CloudresourcemanagerOrganizationsListOrgPolicies_579292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the `Policies` set for a particular resource.
  ## 
  let valid = call_579308.validator(path, query, header, formData, body)
  let scheme = call_579308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579308.url(scheme.get, call_579308.host, call_579308.base,
                         call_579308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579308, url, valid)

proc call*(call_579309: Call_CloudresourcemanagerOrganizationsListOrgPolicies_579292;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerOrganizationsListOrgPolicies
  ## Lists all the `Policies` set for a particular resource.
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
  ##   resource: string (required)
  ##           : Name of the resource to list Policies for.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579310 = newJObject()
  var query_579311 = newJObject()
  var body_579312 = newJObject()
  add(query_579311, "key", newJString(key))
  add(query_579311, "prettyPrint", newJBool(prettyPrint))
  add(query_579311, "oauth_token", newJString(oauthToken))
  add(query_579311, "$.xgafv", newJString(Xgafv))
  add(query_579311, "alt", newJString(alt))
  add(query_579311, "uploadType", newJString(uploadType))
  add(query_579311, "quotaUser", newJString(quotaUser))
  add(path_579310, "resource", newJString(resource))
  if body != nil:
    body_579312 = body
  add(query_579311, "callback", newJString(callback))
  add(query_579311, "fields", newJString(fields))
  add(query_579311, "access_token", newJString(accessToken))
  add(query_579311, "upload_protocol", newJString(uploadProtocol))
  result = call_579309.call(path_579310, query_579311, nil, nil, body_579312)

var cloudresourcemanagerOrganizationsListOrgPolicies* = Call_CloudresourcemanagerOrganizationsListOrgPolicies_579292(
    name: "cloudresourcemanagerOrganizationsListOrgPolicies",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:listOrgPolicies",
    validator: validate_CloudresourcemanagerOrganizationsListOrgPolicies_579293,
    base: "/", url: url_CloudresourcemanagerOrganizationsListOrgPolicies_579294,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsSetIamPolicy_579313 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerOrganizationsSetIamPolicy_579315(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsSetIamPolicy_579314(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the access control policy on an Organization resource. Replaces any
  ## existing policy. The `resource` field should be the organization's resource
  ## name, e.g. "organizations/123".
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.organizations.setIamPolicy` on the specified organization
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579316 = path.getOrDefault("resource")
  valid_579316 = validateParameter(valid_579316, JString, required = true,
                                 default = nil)
  if valid_579316 != nil:
    section.add "resource", valid_579316
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
  var valid_579317 = query.getOrDefault("key")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "key", valid_579317
  var valid_579318 = query.getOrDefault("prettyPrint")
  valid_579318 = validateParameter(valid_579318, JBool, required = false,
                                 default = newJBool(true))
  if valid_579318 != nil:
    section.add "prettyPrint", valid_579318
  var valid_579319 = query.getOrDefault("oauth_token")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "oauth_token", valid_579319
  var valid_579320 = query.getOrDefault("$.xgafv")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = newJString("1"))
  if valid_579320 != nil:
    section.add "$.xgafv", valid_579320
  var valid_579321 = query.getOrDefault("alt")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = newJString("json"))
  if valid_579321 != nil:
    section.add "alt", valid_579321
  var valid_579322 = query.getOrDefault("uploadType")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "uploadType", valid_579322
  var valid_579323 = query.getOrDefault("quotaUser")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = nil)
  if valid_579323 != nil:
    section.add "quotaUser", valid_579323
  var valid_579324 = query.getOrDefault("callback")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "callback", valid_579324
  var valid_579325 = query.getOrDefault("fields")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = nil)
  if valid_579325 != nil:
    section.add "fields", valid_579325
  var valid_579326 = query.getOrDefault("access_token")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "access_token", valid_579326
  var valid_579327 = query.getOrDefault("upload_protocol")
  valid_579327 = validateParameter(valid_579327, JString, required = false,
                                 default = nil)
  if valid_579327 != nil:
    section.add "upload_protocol", valid_579327
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

proc call*(call_579329: Call_CloudresourcemanagerOrganizationsSetIamPolicy_579313;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on an Organization resource. Replaces any
  ## existing policy. The `resource` field should be the organization's resource
  ## name, e.g. "organizations/123".
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.organizations.setIamPolicy` on the specified organization
  ## 
  let valid = call_579329.validator(path, query, header, formData, body)
  let scheme = call_579329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579329.url(scheme.get, call_579329.host, call_579329.base,
                         call_579329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579329, url, valid)

proc call*(call_579330: Call_CloudresourcemanagerOrganizationsSetIamPolicy_579313;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerOrganizationsSetIamPolicy
  ## Sets the access control policy on an Organization resource. Replaces any
  ## existing policy. The `resource` field should be the organization's resource
  ## name, e.g. "organizations/123".
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.organizations.setIamPolicy` on the specified organization
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579331 = newJObject()
  var query_579332 = newJObject()
  var body_579333 = newJObject()
  add(query_579332, "key", newJString(key))
  add(query_579332, "prettyPrint", newJBool(prettyPrint))
  add(query_579332, "oauth_token", newJString(oauthToken))
  add(query_579332, "$.xgafv", newJString(Xgafv))
  add(query_579332, "alt", newJString(alt))
  add(query_579332, "uploadType", newJString(uploadType))
  add(query_579332, "quotaUser", newJString(quotaUser))
  add(path_579331, "resource", newJString(resource))
  if body != nil:
    body_579333 = body
  add(query_579332, "callback", newJString(callback))
  add(query_579332, "fields", newJString(fields))
  add(query_579332, "access_token", newJString(accessToken))
  add(query_579332, "upload_protocol", newJString(uploadProtocol))
  result = call_579330.call(path_579331, query_579332, nil, nil, body_579333)

var cloudresourcemanagerOrganizationsSetIamPolicy* = Call_CloudresourcemanagerOrganizationsSetIamPolicy_579313(
    name: "cloudresourcemanagerOrganizationsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_CloudresourcemanagerOrganizationsSetIamPolicy_579314,
    base: "/", url: url_CloudresourcemanagerOrganizationsSetIamPolicy_579315,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsSetOrgPolicy_579334 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerOrganizationsSetOrgPolicy_579336(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setOrgPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsSetOrgPolicy_579335(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the specified `Policy` on the resource. Creates a new `Policy` for
  ## that `Constraint` on the resource if one does not exist.
  ## 
  ## Not supplying an `etag` on the request `Policy` results in an unconditional
  ## write of the `Policy`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Resource name of the resource to attach the `Policy`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579337 = path.getOrDefault("resource")
  valid_579337 = validateParameter(valid_579337, JString, required = true,
                                 default = nil)
  if valid_579337 != nil:
    section.add "resource", valid_579337
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
  var valid_579338 = query.getOrDefault("key")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = nil)
  if valid_579338 != nil:
    section.add "key", valid_579338
  var valid_579339 = query.getOrDefault("prettyPrint")
  valid_579339 = validateParameter(valid_579339, JBool, required = false,
                                 default = newJBool(true))
  if valid_579339 != nil:
    section.add "prettyPrint", valid_579339
  var valid_579340 = query.getOrDefault("oauth_token")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "oauth_token", valid_579340
  var valid_579341 = query.getOrDefault("$.xgafv")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = newJString("1"))
  if valid_579341 != nil:
    section.add "$.xgafv", valid_579341
  var valid_579342 = query.getOrDefault("alt")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = newJString("json"))
  if valid_579342 != nil:
    section.add "alt", valid_579342
  var valid_579343 = query.getOrDefault("uploadType")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "uploadType", valid_579343
  var valid_579344 = query.getOrDefault("quotaUser")
  valid_579344 = validateParameter(valid_579344, JString, required = false,
                                 default = nil)
  if valid_579344 != nil:
    section.add "quotaUser", valid_579344
  var valid_579345 = query.getOrDefault("callback")
  valid_579345 = validateParameter(valid_579345, JString, required = false,
                                 default = nil)
  if valid_579345 != nil:
    section.add "callback", valid_579345
  var valid_579346 = query.getOrDefault("fields")
  valid_579346 = validateParameter(valid_579346, JString, required = false,
                                 default = nil)
  if valid_579346 != nil:
    section.add "fields", valid_579346
  var valid_579347 = query.getOrDefault("access_token")
  valid_579347 = validateParameter(valid_579347, JString, required = false,
                                 default = nil)
  if valid_579347 != nil:
    section.add "access_token", valid_579347
  var valid_579348 = query.getOrDefault("upload_protocol")
  valid_579348 = validateParameter(valid_579348, JString, required = false,
                                 default = nil)
  if valid_579348 != nil:
    section.add "upload_protocol", valid_579348
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

proc call*(call_579350: Call_CloudresourcemanagerOrganizationsSetOrgPolicy_579334;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified `Policy` on the resource. Creates a new `Policy` for
  ## that `Constraint` on the resource if one does not exist.
  ## 
  ## Not supplying an `etag` on the request `Policy` results in an unconditional
  ## write of the `Policy`.
  ## 
  let valid = call_579350.validator(path, query, header, formData, body)
  let scheme = call_579350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579350.url(scheme.get, call_579350.host, call_579350.base,
                         call_579350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579350, url, valid)

proc call*(call_579351: Call_CloudresourcemanagerOrganizationsSetOrgPolicy_579334;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerOrganizationsSetOrgPolicy
  ## Updates the specified `Policy` on the resource. Creates a new `Policy` for
  ## that `Constraint` on the resource if one does not exist.
  ## 
  ## Not supplying an `etag` on the request `Policy` results in an unconditional
  ## write of the `Policy`.
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
  ##   resource: string (required)
  ##           : Resource name of the resource to attach the `Policy`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579352 = newJObject()
  var query_579353 = newJObject()
  var body_579354 = newJObject()
  add(query_579353, "key", newJString(key))
  add(query_579353, "prettyPrint", newJBool(prettyPrint))
  add(query_579353, "oauth_token", newJString(oauthToken))
  add(query_579353, "$.xgafv", newJString(Xgafv))
  add(query_579353, "alt", newJString(alt))
  add(query_579353, "uploadType", newJString(uploadType))
  add(query_579353, "quotaUser", newJString(quotaUser))
  add(path_579352, "resource", newJString(resource))
  if body != nil:
    body_579354 = body
  add(query_579353, "callback", newJString(callback))
  add(query_579353, "fields", newJString(fields))
  add(query_579353, "access_token", newJString(accessToken))
  add(query_579353, "upload_protocol", newJString(uploadProtocol))
  result = call_579351.call(path_579352, query_579353, nil, nil, body_579354)

var cloudresourcemanagerOrganizationsSetOrgPolicy* = Call_CloudresourcemanagerOrganizationsSetOrgPolicy_579334(
    name: "cloudresourcemanagerOrganizationsSetOrgPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:setOrgPolicy",
    validator: validate_CloudresourcemanagerOrganizationsSetOrgPolicy_579335,
    base: "/", url: url_CloudresourcemanagerOrganizationsSetOrgPolicy_579336,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsTestIamPermissions_579355 = ref object of OpenApiRestCall_578348
proc url_CloudresourcemanagerOrganizationsTestIamPermissions_579357(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsTestIamPermissions_579356(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified Organization.
  ## The `resource` field should be the organization's resource name,
  ## e.g. "organizations/123".
  ## 
  ## There are no permissions required for making this API call.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579358 = path.getOrDefault("resource")
  valid_579358 = validateParameter(valid_579358, JString, required = true,
                                 default = nil)
  if valid_579358 != nil:
    section.add "resource", valid_579358
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
  var valid_579359 = query.getOrDefault("key")
  valid_579359 = validateParameter(valid_579359, JString, required = false,
                                 default = nil)
  if valid_579359 != nil:
    section.add "key", valid_579359
  var valid_579360 = query.getOrDefault("prettyPrint")
  valid_579360 = validateParameter(valid_579360, JBool, required = false,
                                 default = newJBool(true))
  if valid_579360 != nil:
    section.add "prettyPrint", valid_579360
  var valid_579361 = query.getOrDefault("oauth_token")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = nil)
  if valid_579361 != nil:
    section.add "oauth_token", valid_579361
  var valid_579362 = query.getOrDefault("$.xgafv")
  valid_579362 = validateParameter(valid_579362, JString, required = false,
                                 default = newJString("1"))
  if valid_579362 != nil:
    section.add "$.xgafv", valid_579362
  var valid_579363 = query.getOrDefault("alt")
  valid_579363 = validateParameter(valid_579363, JString, required = false,
                                 default = newJString("json"))
  if valid_579363 != nil:
    section.add "alt", valid_579363
  var valid_579364 = query.getOrDefault("uploadType")
  valid_579364 = validateParameter(valid_579364, JString, required = false,
                                 default = nil)
  if valid_579364 != nil:
    section.add "uploadType", valid_579364
  var valid_579365 = query.getOrDefault("quotaUser")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = nil)
  if valid_579365 != nil:
    section.add "quotaUser", valid_579365
  var valid_579366 = query.getOrDefault("callback")
  valid_579366 = validateParameter(valid_579366, JString, required = false,
                                 default = nil)
  if valid_579366 != nil:
    section.add "callback", valid_579366
  var valid_579367 = query.getOrDefault("fields")
  valid_579367 = validateParameter(valid_579367, JString, required = false,
                                 default = nil)
  if valid_579367 != nil:
    section.add "fields", valid_579367
  var valid_579368 = query.getOrDefault("access_token")
  valid_579368 = validateParameter(valid_579368, JString, required = false,
                                 default = nil)
  if valid_579368 != nil:
    section.add "access_token", valid_579368
  var valid_579369 = query.getOrDefault("upload_protocol")
  valid_579369 = validateParameter(valid_579369, JString, required = false,
                                 default = nil)
  if valid_579369 != nil:
    section.add "upload_protocol", valid_579369
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

proc call*(call_579371: Call_CloudresourcemanagerOrganizationsTestIamPermissions_579355;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Organization.
  ## The `resource` field should be the organization's resource name,
  ## e.g. "organizations/123".
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_579371.validator(path, query, header, formData, body)
  let scheme = call_579371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579371.url(scheme.get, call_579371.host, call_579371.base,
                         call_579371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579371, url, valid)

proc call*(call_579372: Call_CloudresourcemanagerOrganizationsTestIamPermissions_579355;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudresourcemanagerOrganizationsTestIamPermissions
  ## Returns permissions that a caller has on the specified Organization.
  ## The `resource` field should be the organization's resource name,
  ## e.g. "organizations/123".
  ## 
  ## There are no permissions required for making this API call.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579373 = newJObject()
  var query_579374 = newJObject()
  var body_579375 = newJObject()
  add(query_579374, "key", newJString(key))
  add(query_579374, "prettyPrint", newJBool(prettyPrint))
  add(query_579374, "oauth_token", newJString(oauthToken))
  add(query_579374, "$.xgafv", newJString(Xgafv))
  add(query_579374, "alt", newJString(alt))
  add(query_579374, "uploadType", newJString(uploadType))
  add(query_579374, "quotaUser", newJString(quotaUser))
  add(path_579373, "resource", newJString(resource))
  if body != nil:
    body_579375 = body
  add(query_579374, "callback", newJString(callback))
  add(query_579374, "fields", newJString(fields))
  add(query_579374, "access_token", newJString(accessToken))
  add(query_579374, "upload_protocol", newJString(uploadProtocol))
  result = call_579372.call(path_579373, query_579374, nil, nil, body_579375)

var cloudresourcemanagerOrganizationsTestIamPermissions* = Call_CloudresourcemanagerOrganizationsTestIamPermissions_579355(
    name: "cloudresourcemanagerOrganizationsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_CloudresourcemanagerOrganizationsTestIamPermissions_579356,
    base: "/", url: url_CloudresourcemanagerOrganizationsTestIamPermissions_579357,
    schemes: {Scheme.Https})
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
