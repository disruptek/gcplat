
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Cloud Resource Manager
## version: v1beta1
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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
  gcpServiceName = "cloudresourcemanager"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudresourcemanagerOrganizationsList_597677 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerOrganizationsList_597679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerOrganizationsList_597678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists Organization resources that are visible to the user and satisfy
  ## the specified filter. This method returns Organizations in an unspecified
  ## order. New Organizations do not necessarily appear at the end of the list.
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
  ##            : A pagination token returned from a previous call to `ListOrganizations`
  ## that indicates from where listing should continue.
  ## This field is optional.
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
  ##           : The maximum number of Organizations to return in the response.
  ## This field is optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : An optional query string used to filter the Organizations to return in
  ## the response. Filter rules are case-insensitive.
  ## 
  ## 
  ## Organizations may be filtered by `owner.directoryCustomerId` or by
  ## `domain`, where the domain is a G Suite domain, for example:
  ## 
  ## * Filter `owner.directorycustomerid:123456789` returns Organization
  ## resources with `owner.directory_customer_id` equal to `123456789`.
  ## * Filter `domain:google.com` returns Organization resources corresponding
  ## to the domain `google.com`.
  ## 
  ## This field is optional.
  section = newJObject()
  var valid_597791 = query.getOrDefault("upload_protocol")
  valid_597791 = validateParameter(valid_597791, JString, required = false,
                                 default = nil)
  if valid_597791 != nil:
    section.add "upload_protocol", valid_597791
  var valid_597792 = query.getOrDefault("fields")
  valid_597792 = validateParameter(valid_597792, JString, required = false,
                                 default = nil)
  if valid_597792 != nil:
    section.add "fields", valid_597792
  var valid_597793 = query.getOrDefault("pageToken")
  valid_597793 = validateParameter(valid_597793, JString, required = false,
                                 default = nil)
  if valid_597793 != nil:
    section.add "pageToken", valid_597793
  var valid_597794 = query.getOrDefault("quotaUser")
  valid_597794 = validateParameter(valid_597794, JString, required = false,
                                 default = nil)
  if valid_597794 != nil:
    section.add "quotaUser", valid_597794
  var valid_597808 = query.getOrDefault("alt")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = newJString("json"))
  if valid_597808 != nil:
    section.add "alt", valid_597808
  var valid_597809 = query.getOrDefault("oauth_token")
  valid_597809 = validateParameter(valid_597809, JString, required = false,
                                 default = nil)
  if valid_597809 != nil:
    section.add "oauth_token", valid_597809
  var valid_597810 = query.getOrDefault("callback")
  valid_597810 = validateParameter(valid_597810, JString, required = false,
                                 default = nil)
  if valid_597810 != nil:
    section.add "callback", valid_597810
  var valid_597811 = query.getOrDefault("access_token")
  valid_597811 = validateParameter(valid_597811, JString, required = false,
                                 default = nil)
  if valid_597811 != nil:
    section.add "access_token", valid_597811
  var valid_597812 = query.getOrDefault("uploadType")
  valid_597812 = validateParameter(valid_597812, JString, required = false,
                                 default = nil)
  if valid_597812 != nil:
    section.add "uploadType", valid_597812
  var valid_597813 = query.getOrDefault("key")
  valid_597813 = validateParameter(valid_597813, JString, required = false,
                                 default = nil)
  if valid_597813 != nil:
    section.add "key", valid_597813
  var valid_597814 = query.getOrDefault("$.xgafv")
  valid_597814 = validateParameter(valid_597814, JString, required = false,
                                 default = newJString("1"))
  if valid_597814 != nil:
    section.add "$.xgafv", valid_597814
  var valid_597815 = query.getOrDefault("pageSize")
  valid_597815 = validateParameter(valid_597815, JInt, required = false, default = nil)
  if valid_597815 != nil:
    section.add "pageSize", valid_597815
  var valid_597816 = query.getOrDefault("prettyPrint")
  valid_597816 = validateParameter(valid_597816, JBool, required = false,
                                 default = newJBool(true))
  if valid_597816 != nil:
    section.add "prettyPrint", valid_597816
  var valid_597817 = query.getOrDefault("filter")
  valid_597817 = validateParameter(valid_597817, JString, required = false,
                                 default = nil)
  if valid_597817 != nil:
    section.add "filter", valid_597817
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597840: Call_CloudresourcemanagerOrganizationsList_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Organization resources that are visible to the user and satisfy
  ## the specified filter. This method returns Organizations in an unspecified
  ## order. New Organizations do not necessarily appear at the end of the list.
  ## 
  let valid = call_597840.validator(path, query, header, formData, body)
  let scheme = call_597840.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597840.url(scheme.get, call_597840.host, call_597840.base,
                         call_597840.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597840, url, valid)

proc call*(call_597911: Call_CloudresourcemanagerOrganizationsList_597677;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## cloudresourcemanagerOrganizationsList
  ## Lists Organization resources that are visible to the user and satisfy
  ## the specified filter. This method returns Organizations in an unspecified
  ## order. New Organizations do not necessarily appear at the end of the list.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to `ListOrganizations`
  ## that indicates from where listing should continue.
  ## This field is optional.
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
  ##           : The maximum number of Organizations to return in the response.
  ## This field is optional.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : An optional query string used to filter the Organizations to return in
  ## the response. Filter rules are case-insensitive.
  ## 
  ## 
  ## Organizations may be filtered by `owner.directoryCustomerId` or by
  ## `domain`, where the domain is a G Suite domain, for example:
  ## 
  ## * Filter `owner.directorycustomerid:123456789` returns Organization
  ## resources with `owner.directory_customer_id` equal to `123456789`.
  ## * Filter `domain:google.com` returns Organization resources corresponding
  ## to the domain `google.com`.
  ## 
  ## This field is optional.
  var query_597912 = newJObject()
  add(query_597912, "upload_protocol", newJString(uploadProtocol))
  add(query_597912, "fields", newJString(fields))
  add(query_597912, "pageToken", newJString(pageToken))
  add(query_597912, "quotaUser", newJString(quotaUser))
  add(query_597912, "alt", newJString(alt))
  add(query_597912, "oauth_token", newJString(oauthToken))
  add(query_597912, "callback", newJString(callback))
  add(query_597912, "access_token", newJString(accessToken))
  add(query_597912, "uploadType", newJString(uploadType))
  add(query_597912, "key", newJString(key))
  add(query_597912, "$.xgafv", newJString(Xgafv))
  add(query_597912, "pageSize", newJInt(pageSize))
  add(query_597912, "prettyPrint", newJBool(prettyPrint))
  add(query_597912, "filter", newJString(filter))
  result = call_597911.call(nil, query_597912, nil, nil, nil)

var cloudresourcemanagerOrganizationsList* = Call_CloudresourcemanagerOrganizationsList_597677(
    name: "cloudresourcemanagerOrganizationsList", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1beta1/organizations",
    validator: validate_CloudresourcemanagerOrganizationsList_597678, base: "/",
    url: url_CloudresourcemanagerOrganizationsList_597679, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsCreate_597972 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerProjectsCreate_597974(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerProjectsCreate_597973(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Project resource.
  ## 
  ## Initially, the Project resource is owned by its creator exclusively.
  ## The creator can later grant permission to others to read or update the
  ## Project.
  ## 
  ## Several APIs are activated automatically for the Project, including
  ## Google Cloud Storage. The parent is identified by a specified
  ## ResourceId, which must include both an ID and a type, such as
  ## project, folder, or organization.
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
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   useLegacyStack: JBool
  ##                 : A safety hatch to opt out of the new reliable project creation process.
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
  var valid_597975 = query.getOrDefault("upload_protocol")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "upload_protocol", valid_597975
  var valid_597976 = query.getOrDefault("fields")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "fields", valid_597976
  var valid_597977 = query.getOrDefault("useLegacyStack")
  valid_597977 = validateParameter(valid_597977, JBool, required = false, default = nil)
  if valid_597977 != nil:
    section.add "useLegacyStack", valid_597977
  var valid_597978 = query.getOrDefault("quotaUser")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = nil)
  if valid_597978 != nil:
    section.add "quotaUser", valid_597978
  var valid_597979 = query.getOrDefault("alt")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = newJString("json"))
  if valid_597979 != nil:
    section.add "alt", valid_597979
  var valid_597980 = query.getOrDefault("oauth_token")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "oauth_token", valid_597980
  var valid_597981 = query.getOrDefault("callback")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "callback", valid_597981
  var valid_597982 = query.getOrDefault("access_token")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = nil)
  if valid_597982 != nil:
    section.add "access_token", valid_597982
  var valid_597983 = query.getOrDefault("uploadType")
  valid_597983 = validateParameter(valid_597983, JString, required = false,
                                 default = nil)
  if valid_597983 != nil:
    section.add "uploadType", valid_597983
  var valid_597984 = query.getOrDefault("key")
  valid_597984 = validateParameter(valid_597984, JString, required = false,
                                 default = nil)
  if valid_597984 != nil:
    section.add "key", valid_597984
  var valid_597985 = query.getOrDefault("$.xgafv")
  valid_597985 = validateParameter(valid_597985, JString, required = false,
                                 default = newJString("1"))
  if valid_597985 != nil:
    section.add "$.xgafv", valid_597985
  var valid_597986 = query.getOrDefault("prettyPrint")
  valid_597986 = validateParameter(valid_597986, JBool, required = false,
                                 default = newJBool(true))
  if valid_597986 != nil:
    section.add "prettyPrint", valid_597986
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

proc call*(call_597988: Call_CloudresourcemanagerProjectsCreate_597972;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Project resource.
  ## 
  ## Initially, the Project resource is owned by its creator exclusively.
  ## The creator can later grant permission to others to read or update the
  ## Project.
  ## 
  ## Several APIs are activated automatically for the Project, including
  ## Google Cloud Storage. The parent is identified by a specified
  ## ResourceId, which must include both an ID and a type, such as
  ## project, folder, or organization.
  ## 
  ## This method does not associate the new project with a billing account.
  ## You can set or update the billing account associated with a project using
  ## the [`projects.updateBillingInfo`]
  ## (/billing/reference/rest/v1/projects/updateBillingInfo) method.
  ## 
  let valid = call_597988.validator(path, query, header, formData, body)
  let scheme = call_597988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597988.url(scheme.get, call_597988.host, call_597988.base,
                         call_597988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597988, url, valid)

proc call*(call_597989: Call_CloudresourcemanagerProjectsCreate_597972;
          uploadProtocol: string = ""; fields: string = "";
          useLegacyStack: bool = false; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsCreate
  ## Creates a Project resource.
  ## 
  ## Initially, the Project resource is owned by its creator exclusively.
  ## The creator can later grant permission to others to read or update the
  ## Project.
  ## 
  ## Several APIs are activated automatically for the Project, including
  ## Google Cloud Storage. The parent is identified by a specified
  ## ResourceId, which must include both an ID and a type, such as
  ## project, folder, or organization.
  ## 
  ## This method does not associate the new project with a billing account.
  ## You can set or update the billing account associated with a project using
  ## the [`projects.updateBillingInfo`]
  ## (/billing/reference/rest/v1/projects/updateBillingInfo) method.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   useLegacyStack: bool
  ##                 : A safety hatch to opt out of the new reliable project creation process.
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
  var query_597990 = newJObject()
  var body_597991 = newJObject()
  add(query_597990, "upload_protocol", newJString(uploadProtocol))
  add(query_597990, "fields", newJString(fields))
  add(query_597990, "useLegacyStack", newJBool(useLegacyStack))
  add(query_597990, "quotaUser", newJString(quotaUser))
  add(query_597990, "alt", newJString(alt))
  add(query_597990, "oauth_token", newJString(oauthToken))
  add(query_597990, "callback", newJString(callback))
  add(query_597990, "access_token", newJString(accessToken))
  add(query_597990, "uploadType", newJString(uploadType))
  add(query_597990, "key", newJString(key))
  add(query_597990, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597991 = body
  add(query_597990, "prettyPrint", newJBool(prettyPrint))
  result = call_597989.call(nil, query_597990, nil, nil, body_597991)

var cloudresourcemanagerProjectsCreate* = Call_CloudresourcemanagerProjectsCreate_597972(
    name: "cloudresourcemanagerProjectsCreate", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v1beta1/projects",
    validator: validate_CloudresourcemanagerProjectsCreate_597973, base: "/",
    url: url_CloudresourcemanagerProjectsCreate_597974, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsList_597952 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerProjectsList_597954(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerProjectsList_597953(path: JsonNode;
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
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to ListProjects
  ## that indicates from where listing should continue.
  ## 
  ## Optional.
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
  ##           : The maximum number of Projects to return in the response.
  ## The server can return fewer Projects than requested.
  ## If unspecified, server picks an appropriate default.
  ## 
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
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
  section = newJObject()
  var valid_597955 = query.getOrDefault("upload_protocol")
  valid_597955 = validateParameter(valid_597955, JString, required = false,
                                 default = nil)
  if valid_597955 != nil:
    section.add "upload_protocol", valid_597955
  var valid_597956 = query.getOrDefault("fields")
  valid_597956 = validateParameter(valid_597956, JString, required = false,
                                 default = nil)
  if valid_597956 != nil:
    section.add "fields", valid_597956
  var valid_597957 = query.getOrDefault("pageToken")
  valid_597957 = validateParameter(valid_597957, JString, required = false,
                                 default = nil)
  if valid_597957 != nil:
    section.add "pageToken", valid_597957
  var valid_597958 = query.getOrDefault("quotaUser")
  valid_597958 = validateParameter(valid_597958, JString, required = false,
                                 default = nil)
  if valid_597958 != nil:
    section.add "quotaUser", valid_597958
  var valid_597959 = query.getOrDefault("alt")
  valid_597959 = validateParameter(valid_597959, JString, required = false,
                                 default = newJString("json"))
  if valid_597959 != nil:
    section.add "alt", valid_597959
  var valid_597960 = query.getOrDefault("oauth_token")
  valid_597960 = validateParameter(valid_597960, JString, required = false,
                                 default = nil)
  if valid_597960 != nil:
    section.add "oauth_token", valid_597960
  var valid_597961 = query.getOrDefault("callback")
  valid_597961 = validateParameter(valid_597961, JString, required = false,
                                 default = nil)
  if valid_597961 != nil:
    section.add "callback", valid_597961
  var valid_597962 = query.getOrDefault("access_token")
  valid_597962 = validateParameter(valid_597962, JString, required = false,
                                 default = nil)
  if valid_597962 != nil:
    section.add "access_token", valid_597962
  var valid_597963 = query.getOrDefault("uploadType")
  valid_597963 = validateParameter(valid_597963, JString, required = false,
                                 default = nil)
  if valid_597963 != nil:
    section.add "uploadType", valid_597963
  var valid_597964 = query.getOrDefault("key")
  valid_597964 = validateParameter(valid_597964, JString, required = false,
                                 default = nil)
  if valid_597964 != nil:
    section.add "key", valid_597964
  var valid_597965 = query.getOrDefault("$.xgafv")
  valid_597965 = validateParameter(valid_597965, JString, required = false,
                                 default = newJString("1"))
  if valid_597965 != nil:
    section.add "$.xgafv", valid_597965
  var valid_597966 = query.getOrDefault("pageSize")
  valid_597966 = validateParameter(valid_597966, JInt, required = false, default = nil)
  if valid_597966 != nil:
    section.add "pageSize", valid_597966
  var valid_597967 = query.getOrDefault("prettyPrint")
  valid_597967 = validateParameter(valid_597967, JBool, required = false,
                                 default = newJBool(true))
  if valid_597967 != nil:
    section.add "prettyPrint", valid_597967
  var valid_597968 = query.getOrDefault("filter")
  valid_597968 = validateParameter(valid_597968, JString, required = false,
                                 default = nil)
  if valid_597968 != nil:
    section.add "filter", valid_597968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597969: Call_CloudresourcemanagerProjectsList_597952;
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
  let valid = call_597969.validator(path, query, header, formData, body)
  let scheme = call_597969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597969.url(scheme.get, call_597969.host, call_597969.base,
                         call_597969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597969, url, valid)

proc call*(call_597970: Call_CloudresourcemanagerProjectsList_597952;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to ListProjects
  ## that indicates from where listing should continue.
  ## 
  ## Optional.
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
  ##           : The maximum number of Projects to return in the response.
  ## The server can return fewer Projects than requested.
  ## If unspecified, server picks an appropriate default.
  ## 
  ## Optional.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
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
  var query_597971 = newJObject()
  add(query_597971, "upload_protocol", newJString(uploadProtocol))
  add(query_597971, "fields", newJString(fields))
  add(query_597971, "pageToken", newJString(pageToken))
  add(query_597971, "quotaUser", newJString(quotaUser))
  add(query_597971, "alt", newJString(alt))
  add(query_597971, "oauth_token", newJString(oauthToken))
  add(query_597971, "callback", newJString(callback))
  add(query_597971, "access_token", newJString(accessToken))
  add(query_597971, "uploadType", newJString(uploadType))
  add(query_597971, "key", newJString(key))
  add(query_597971, "$.xgafv", newJString(Xgafv))
  add(query_597971, "pageSize", newJInt(pageSize))
  add(query_597971, "prettyPrint", newJBool(prettyPrint))
  add(query_597971, "filter", newJString(filter))
  result = call_597970.call(nil, query_597971, nil, nil, nil)

var cloudresourcemanagerProjectsList* = Call_CloudresourcemanagerProjectsList_597952(
    name: "cloudresourcemanagerProjectsList", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1beta1/projects",
    validator: validate_CloudresourcemanagerProjectsList_597953, base: "/",
    url: url_CloudresourcemanagerProjectsList_597954, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsUpdate_598025 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerProjectsUpdate_598027(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsUpdate_598026(path: JsonNode;
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
  var valid_598028 = path.getOrDefault("projectId")
  valid_598028 = validateParameter(valid_598028, JString, required = true,
                                 default = nil)
  if valid_598028 != nil:
    section.add "projectId", valid_598028
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
  var valid_598029 = query.getOrDefault("upload_protocol")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = nil)
  if valid_598029 != nil:
    section.add "upload_protocol", valid_598029
  var valid_598030 = query.getOrDefault("fields")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "fields", valid_598030
  var valid_598031 = query.getOrDefault("quotaUser")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "quotaUser", valid_598031
  var valid_598032 = query.getOrDefault("alt")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = newJString("json"))
  if valid_598032 != nil:
    section.add "alt", valid_598032
  var valid_598033 = query.getOrDefault("oauth_token")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "oauth_token", valid_598033
  var valid_598034 = query.getOrDefault("callback")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "callback", valid_598034
  var valid_598035 = query.getOrDefault("access_token")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "access_token", valid_598035
  var valid_598036 = query.getOrDefault("uploadType")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "uploadType", valid_598036
  var valid_598037 = query.getOrDefault("key")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "key", valid_598037
  var valid_598038 = query.getOrDefault("$.xgafv")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = newJString("1"))
  if valid_598038 != nil:
    section.add "$.xgafv", valid_598038
  var valid_598039 = query.getOrDefault("prettyPrint")
  valid_598039 = validateParameter(valid_598039, JBool, required = false,
                                 default = newJBool(true))
  if valid_598039 != nil:
    section.add "prettyPrint", valid_598039
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

proc call*(call_598041: Call_CloudresourcemanagerProjectsUpdate_598025;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the attributes of the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  let valid = call_598041.validator(path, query, header, formData, body)
  let scheme = call_598041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598041.url(scheme.get, call_598041.host, call_598041.base,
                         call_598041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598041, url, valid)

proc call*(call_598042: Call_CloudresourcemanagerProjectsUpdate_598025;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsUpdate
  ## Updates the attributes of the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have modify permissions for this Project.
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
  ##   projectId: string (required)
  ##            : The project ID (for example, `my-project-123`).
  ## 
  ## Required.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598043 = newJObject()
  var query_598044 = newJObject()
  var body_598045 = newJObject()
  add(query_598044, "upload_protocol", newJString(uploadProtocol))
  add(query_598044, "fields", newJString(fields))
  add(query_598044, "quotaUser", newJString(quotaUser))
  add(query_598044, "alt", newJString(alt))
  add(query_598044, "oauth_token", newJString(oauthToken))
  add(query_598044, "callback", newJString(callback))
  add(query_598044, "access_token", newJString(accessToken))
  add(query_598044, "uploadType", newJString(uploadType))
  add(query_598044, "key", newJString(key))
  add(path_598043, "projectId", newJString(projectId))
  add(query_598044, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598045 = body
  add(query_598044, "prettyPrint", newJBool(prettyPrint))
  result = call_598042.call(path_598043, query_598044, nil, nil, body_598045)

var cloudresourcemanagerProjectsUpdate* = Call_CloudresourcemanagerProjectsUpdate_598025(
    name: "cloudresourcemanagerProjectsUpdate", meth: HttpMethod.HttpPut,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/projects/{projectId}",
    validator: validate_CloudresourcemanagerProjectsUpdate_598026, base: "/",
    url: url_CloudresourcemanagerProjectsUpdate_598027, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsGet_597992 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerProjectsGet_597994(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsGet_597993(path: JsonNode;
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
  var valid_598009 = path.getOrDefault("projectId")
  valid_598009 = validateParameter(valid_598009, JString, required = true,
                                 default = nil)
  if valid_598009 != nil:
    section.add "projectId", valid_598009
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
  var valid_598010 = query.getOrDefault("upload_protocol")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = nil)
  if valid_598010 != nil:
    section.add "upload_protocol", valid_598010
  var valid_598011 = query.getOrDefault("fields")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "fields", valid_598011
  var valid_598012 = query.getOrDefault("quotaUser")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "quotaUser", valid_598012
  var valid_598013 = query.getOrDefault("alt")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = newJString("json"))
  if valid_598013 != nil:
    section.add "alt", valid_598013
  var valid_598014 = query.getOrDefault("oauth_token")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "oauth_token", valid_598014
  var valid_598015 = query.getOrDefault("callback")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "callback", valid_598015
  var valid_598016 = query.getOrDefault("access_token")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "access_token", valid_598016
  var valid_598017 = query.getOrDefault("uploadType")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "uploadType", valid_598017
  var valid_598018 = query.getOrDefault("key")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "key", valid_598018
  var valid_598019 = query.getOrDefault("$.xgafv")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = newJString("1"))
  if valid_598019 != nil:
    section.add "$.xgafv", valid_598019
  var valid_598020 = query.getOrDefault("prettyPrint")
  valid_598020 = validateParameter(valid_598020, JBool, required = false,
                                 default = newJBool(true))
  if valid_598020 != nil:
    section.add "prettyPrint", valid_598020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598021: Call_CloudresourcemanagerProjectsGet_597992;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
  ## 
  let valid = call_598021.validator(path, query, header, formData, body)
  let scheme = call_598021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598021.url(scheme.get, call_598021.host, call_598021.base,
                         call_598021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598021, url, valid)

proc call*(call_598022: Call_CloudresourcemanagerProjectsGet_597992;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsGet
  ## Retrieves the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
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
  ##   projectId: string (required)
  ##            : The Project ID (for example, `my-project-123`).
  ## 
  ## Required.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598023 = newJObject()
  var query_598024 = newJObject()
  add(query_598024, "upload_protocol", newJString(uploadProtocol))
  add(query_598024, "fields", newJString(fields))
  add(query_598024, "quotaUser", newJString(quotaUser))
  add(query_598024, "alt", newJString(alt))
  add(query_598024, "oauth_token", newJString(oauthToken))
  add(query_598024, "callback", newJString(callback))
  add(query_598024, "access_token", newJString(accessToken))
  add(query_598024, "uploadType", newJString(uploadType))
  add(query_598024, "key", newJString(key))
  add(path_598023, "projectId", newJString(projectId))
  add(query_598024, "$.xgafv", newJString(Xgafv))
  add(query_598024, "prettyPrint", newJBool(prettyPrint))
  result = call_598022.call(path_598023, query_598024, nil, nil, nil)

var cloudresourcemanagerProjectsGet* = Call_CloudresourcemanagerProjectsGet_597992(
    name: "cloudresourcemanagerProjectsGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/projects/{projectId}",
    validator: validate_CloudresourcemanagerProjectsGet_597993, base: "/",
    url: url_CloudresourcemanagerProjectsGet_597994, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsDelete_598046 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerProjectsDelete_598048(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsDelete_598047(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Marks the Project identified by the specified
  ## `project_id` (for example, `my-project-123`) for deletion.
  ## This method will only affect the Project if it has a lifecycle state of
  ## ACTIVE.
  ## 
  ## This method changes the Project's lifecycle state from
  ## ACTIVE
  ## to DELETE_REQUESTED.
  ## The deletion starts at an unspecified time, at which point the project is
  ## no longer accessible.
  ## 
  ## Until the deletion completes, you can check the lifecycle state
  ## checked by retrieving the Project with GetProject,
  ## and the Project remains visible to ListProjects.
  ## However, you cannot update the project.
  ## 
  ## After the deletion completes, the Project is not retrievable by
  ## the  GetProject
  ## and ListProjects
  ## methods.
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
  var valid_598049 = path.getOrDefault("projectId")
  valid_598049 = validateParameter(valid_598049, JString, required = true,
                                 default = nil)
  if valid_598049 != nil:
    section.add "projectId", valid_598049
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
  var valid_598050 = query.getOrDefault("upload_protocol")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = nil)
  if valid_598050 != nil:
    section.add "upload_protocol", valid_598050
  var valid_598051 = query.getOrDefault("fields")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = nil)
  if valid_598051 != nil:
    section.add "fields", valid_598051
  var valid_598052 = query.getOrDefault("quotaUser")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = nil)
  if valid_598052 != nil:
    section.add "quotaUser", valid_598052
  var valid_598053 = query.getOrDefault("alt")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = newJString("json"))
  if valid_598053 != nil:
    section.add "alt", valid_598053
  var valid_598054 = query.getOrDefault("oauth_token")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "oauth_token", valid_598054
  var valid_598055 = query.getOrDefault("callback")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "callback", valid_598055
  var valid_598056 = query.getOrDefault("access_token")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "access_token", valid_598056
  var valid_598057 = query.getOrDefault("uploadType")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "uploadType", valid_598057
  var valid_598058 = query.getOrDefault("key")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "key", valid_598058
  var valid_598059 = query.getOrDefault("$.xgafv")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = newJString("1"))
  if valid_598059 != nil:
    section.add "$.xgafv", valid_598059
  var valid_598060 = query.getOrDefault("prettyPrint")
  valid_598060 = validateParameter(valid_598060, JBool, required = false,
                                 default = newJBool(true))
  if valid_598060 != nil:
    section.add "prettyPrint", valid_598060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598061: Call_CloudresourcemanagerProjectsDelete_598046;
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
  ## The deletion starts at an unspecified time, at which point the project is
  ## no longer accessible.
  ## 
  ## Until the deletion completes, you can check the lifecycle state
  ## checked by retrieving the Project with GetProject,
  ## and the Project remains visible to ListProjects.
  ## However, you cannot update the project.
  ## 
  ## After the deletion completes, the Project is not retrievable by
  ## the  GetProject
  ## and ListProjects
  ## methods.
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  let valid = call_598061.validator(path, query, header, formData, body)
  let scheme = call_598061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598061.url(scheme.get, call_598061.host, call_598061.base,
                         call_598061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598061, url, valid)

proc call*(call_598062: Call_CloudresourcemanagerProjectsDelete_598046;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsDelete
  ## Marks the Project identified by the specified
  ## `project_id` (for example, `my-project-123`) for deletion.
  ## This method will only affect the Project if it has a lifecycle state of
  ## ACTIVE.
  ## 
  ## This method changes the Project's lifecycle state from
  ## ACTIVE
  ## to DELETE_REQUESTED.
  ## The deletion starts at an unspecified time, at which point the project is
  ## no longer accessible.
  ## 
  ## Until the deletion completes, you can check the lifecycle state
  ## checked by retrieving the Project with GetProject,
  ## and the Project remains visible to ListProjects.
  ## However, you cannot update the project.
  ## 
  ## After the deletion completes, the Project is not retrievable by
  ## the  GetProject
  ## and ListProjects
  ## methods.
  ## 
  ## The caller must have modify permissions for this Project.
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
  ##   projectId: string (required)
  ##            : The Project ID (for example, `foo-bar-123`).
  ## 
  ## Required.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598063 = newJObject()
  var query_598064 = newJObject()
  add(query_598064, "upload_protocol", newJString(uploadProtocol))
  add(query_598064, "fields", newJString(fields))
  add(query_598064, "quotaUser", newJString(quotaUser))
  add(query_598064, "alt", newJString(alt))
  add(query_598064, "oauth_token", newJString(oauthToken))
  add(query_598064, "callback", newJString(callback))
  add(query_598064, "access_token", newJString(accessToken))
  add(query_598064, "uploadType", newJString(uploadType))
  add(query_598064, "key", newJString(key))
  add(path_598063, "projectId", newJString(projectId))
  add(query_598064, "$.xgafv", newJString(Xgafv))
  add(query_598064, "prettyPrint", newJBool(prettyPrint))
  result = call_598062.call(path_598063, query_598064, nil, nil, nil)

var cloudresourcemanagerProjectsDelete* = Call_CloudresourcemanagerProjectsDelete_598046(
    name: "cloudresourcemanagerProjectsDelete", meth: HttpMethod.HttpDelete,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/projects/{projectId}",
    validator: validate_CloudresourcemanagerProjectsDelete_598047, base: "/",
    url: url_CloudresourcemanagerProjectsDelete_598048, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsGetAncestry_598065 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerProjectsGetAncestry_598067(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: ":getAncestry")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsGetAncestry_598066(path: JsonNode;
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
  var valid_598068 = path.getOrDefault("projectId")
  valid_598068 = validateParameter(valid_598068, JString, required = true,
                                 default = nil)
  if valid_598068 != nil:
    section.add "projectId", valid_598068
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
  var valid_598069 = query.getOrDefault("upload_protocol")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = nil)
  if valid_598069 != nil:
    section.add "upload_protocol", valid_598069
  var valid_598070 = query.getOrDefault("fields")
  valid_598070 = validateParameter(valid_598070, JString, required = false,
                                 default = nil)
  if valid_598070 != nil:
    section.add "fields", valid_598070
  var valid_598071 = query.getOrDefault("quotaUser")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = nil)
  if valid_598071 != nil:
    section.add "quotaUser", valid_598071
  var valid_598072 = query.getOrDefault("alt")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = newJString("json"))
  if valid_598072 != nil:
    section.add "alt", valid_598072
  var valid_598073 = query.getOrDefault("oauth_token")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = nil)
  if valid_598073 != nil:
    section.add "oauth_token", valid_598073
  var valid_598074 = query.getOrDefault("callback")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "callback", valid_598074
  var valid_598075 = query.getOrDefault("access_token")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "access_token", valid_598075
  var valid_598076 = query.getOrDefault("uploadType")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "uploadType", valid_598076
  var valid_598077 = query.getOrDefault("key")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = nil)
  if valid_598077 != nil:
    section.add "key", valid_598077
  var valid_598078 = query.getOrDefault("$.xgafv")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = newJString("1"))
  if valid_598078 != nil:
    section.add "$.xgafv", valid_598078
  var valid_598079 = query.getOrDefault("prettyPrint")
  valid_598079 = validateParameter(valid_598079, JBool, required = false,
                                 default = newJBool(true))
  if valid_598079 != nil:
    section.add "prettyPrint", valid_598079
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

proc call*(call_598081: Call_CloudresourcemanagerProjectsGetAncestry_598065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of ancestors in the resource hierarchy for the Project
  ## identified by the specified `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
  ## 
  let valid = call_598081.validator(path, query, header, formData, body)
  let scheme = call_598081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598081.url(scheme.get, call_598081.host, call_598081.base,
                         call_598081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598081, url, valid)

proc call*(call_598082: Call_CloudresourcemanagerProjectsGetAncestry_598065;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsGetAncestry
  ## Gets a list of ancestors in the resource hierarchy for the Project
  ## identified by the specified `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
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
  ##   projectId: string (required)
  ##            : The Project ID (for example, `my-project-123`).
  ## 
  ## Required.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598083 = newJObject()
  var query_598084 = newJObject()
  var body_598085 = newJObject()
  add(query_598084, "upload_protocol", newJString(uploadProtocol))
  add(query_598084, "fields", newJString(fields))
  add(query_598084, "quotaUser", newJString(quotaUser))
  add(query_598084, "alt", newJString(alt))
  add(query_598084, "oauth_token", newJString(oauthToken))
  add(query_598084, "callback", newJString(callback))
  add(query_598084, "access_token", newJString(accessToken))
  add(query_598084, "uploadType", newJString(uploadType))
  add(query_598084, "key", newJString(key))
  add(path_598083, "projectId", newJString(projectId))
  add(query_598084, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598085 = body
  add(query_598084, "prettyPrint", newJBool(prettyPrint))
  result = call_598082.call(path_598083, query_598084, nil, nil, body_598085)

var cloudresourcemanagerProjectsGetAncestry* = Call_CloudresourcemanagerProjectsGetAncestry_598065(
    name: "cloudresourcemanagerProjectsGetAncestry", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/projects/{projectId}:getAncestry",
    validator: validate_CloudresourcemanagerProjectsGetAncestry_598066, base: "/",
    url: url_CloudresourcemanagerProjectsGetAncestry_598067,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsUndelete_598086 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerProjectsUndelete_598088(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: ":undelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsUndelete_598087(path: JsonNode;
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
  var valid_598089 = path.getOrDefault("projectId")
  valid_598089 = validateParameter(valid_598089, JString, required = true,
                                 default = nil)
  if valid_598089 != nil:
    section.add "projectId", valid_598089
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
  var valid_598090 = query.getOrDefault("upload_protocol")
  valid_598090 = validateParameter(valid_598090, JString, required = false,
                                 default = nil)
  if valid_598090 != nil:
    section.add "upload_protocol", valid_598090
  var valid_598091 = query.getOrDefault("fields")
  valid_598091 = validateParameter(valid_598091, JString, required = false,
                                 default = nil)
  if valid_598091 != nil:
    section.add "fields", valid_598091
  var valid_598092 = query.getOrDefault("quotaUser")
  valid_598092 = validateParameter(valid_598092, JString, required = false,
                                 default = nil)
  if valid_598092 != nil:
    section.add "quotaUser", valid_598092
  var valid_598093 = query.getOrDefault("alt")
  valid_598093 = validateParameter(valid_598093, JString, required = false,
                                 default = newJString("json"))
  if valid_598093 != nil:
    section.add "alt", valid_598093
  var valid_598094 = query.getOrDefault("oauth_token")
  valid_598094 = validateParameter(valid_598094, JString, required = false,
                                 default = nil)
  if valid_598094 != nil:
    section.add "oauth_token", valid_598094
  var valid_598095 = query.getOrDefault("callback")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "callback", valid_598095
  var valid_598096 = query.getOrDefault("access_token")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "access_token", valid_598096
  var valid_598097 = query.getOrDefault("uploadType")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "uploadType", valid_598097
  var valid_598098 = query.getOrDefault("key")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = nil)
  if valid_598098 != nil:
    section.add "key", valid_598098
  var valid_598099 = query.getOrDefault("$.xgafv")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = newJString("1"))
  if valid_598099 != nil:
    section.add "$.xgafv", valid_598099
  var valid_598100 = query.getOrDefault("prettyPrint")
  valid_598100 = validateParameter(valid_598100, JBool, required = false,
                                 default = newJBool(true))
  if valid_598100 != nil:
    section.add "prettyPrint", valid_598100
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

proc call*(call_598102: Call_CloudresourcemanagerProjectsUndelete_598086;
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
  let valid = call_598102.validator(path, query, header, formData, body)
  let scheme = call_598102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598102.url(scheme.get, call_598102.host, call_598102.base,
                         call_598102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598102, url, valid)

proc call*(call_598103: Call_CloudresourcemanagerProjectsUndelete_598086;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsUndelete
  ## Restores the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## You can only use this method for a Project that has a lifecycle state of
  ## DELETE_REQUESTED.
  ## After deletion starts, the Project cannot be restored.
  ## 
  ## The caller must have modify permissions for this Project.
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
  ##   projectId: string (required)
  ##            : The project ID (for example, `foo-bar-123`).
  ## 
  ## Required.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598104 = newJObject()
  var query_598105 = newJObject()
  var body_598106 = newJObject()
  add(query_598105, "upload_protocol", newJString(uploadProtocol))
  add(query_598105, "fields", newJString(fields))
  add(query_598105, "quotaUser", newJString(quotaUser))
  add(query_598105, "alt", newJString(alt))
  add(query_598105, "oauth_token", newJString(oauthToken))
  add(query_598105, "callback", newJString(callback))
  add(query_598105, "access_token", newJString(accessToken))
  add(query_598105, "uploadType", newJString(uploadType))
  add(query_598105, "key", newJString(key))
  add(path_598104, "projectId", newJString(projectId))
  add(query_598105, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598106 = body
  add(query_598105, "prettyPrint", newJBool(prettyPrint))
  result = call_598103.call(path_598104, query_598105, nil, nil, body_598106)

var cloudresourcemanagerProjectsUndelete* = Call_CloudresourcemanagerProjectsUndelete_598086(
    name: "cloudresourcemanagerProjectsUndelete", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/projects/{projectId}:undelete",
    validator: validate_CloudresourcemanagerProjectsUndelete_598087, base: "/",
    url: url_CloudresourcemanagerProjectsUndelete_598088, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsGetIamPolicy_598107 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerProjectsGetIamPolicy_598109(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsGetIamPolicy_598108(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the IAM access control policy for the specified Project.
  ## Permission is denied if the policy or the resource does not exist.
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
  var valid_598110 = path.getOrDefault("resource")
  valid_598110 = validateParameter(valid_598110, JString, required = true,
                                 default = nil)
  if valid_598110 != nil:
    section.add "resource", valid_598110
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
  var valid_598111 = query.getOrDefault("upload_protocol")
  valid_598111 = validateParameter(valid_598111, JString, required = false,
                                 default = nil)
  if valid_598111 != nil:
    section.add "upload_protocol", valid_598111
  var valid_598112 = query.getOrDefault("fields")
  valid_598112 = validateParameter(valid_598112, JString, required = false,
                                 default = nil)
  if valid_598112 != nil:
    section.add "fields", valid_598112
  var valid_598113 = query.getOrDefault("quotaUser")
  valid_598113 = validateParameter(valid_598113, JString, required = false,
                                 default = nil)
  if valid_598113 != nil:
    section.add "quotaUser", valid_598113
  var valid_598114 = query.getOrDefault("alt")
  valid_598114 = validateParameter(valid_598114, JString, required = false,
                                 default = newJString("json"))
  if valid_598114 != nil:
    section.add "alt", valid_598114
  var valid_598115 = query.getOrDefault("oauth_token")
  valid_598115 = validateParameter(valid_598115, JString, required = false,
                                 default = nil)
  if valid_598115 != nil:
    section.add "oauth_token", valid_598115
  var valid_598116 = query.getOrDefault("callback")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = nil)
  if valid_598116 != nil:
    section.add "callback", valid_598116
  var valid_598117 = query.getOrDefault("access_token")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "access_token", valid_598117
  var valid_598118 = query.getOrDefault("uploadType")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = nil)
  if valid_598118 != nil:
    section.add "uploadType", valid_598118
  var valid_598119 = query.getOrDefault("key")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = nil)
  if valid_598119 != nil:
    section.add "key", valid_598119
  var valid_598120 = query.getOrDefault("$.xgafv")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = newJString("1"))
  if valid_598120 != nil:
    section.add "$.xgafv", valid_598120
  var valid_598121 = query.getOrDefault("prettyPrint")
  valid_598121 = validateParameter(valid_598121, JBool, required = false,
                                 default = newJBool(true))
  if valid_598121 != nil:
    section.add "prettyPrint", valid_598121
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

proc call*(call_598123: Call_CloudresourcemanagerProjectsGetIamPolicy_598107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the IAM access control policy for the specified Project.
  ## Permission is denied if the policy or the resource does not exist.
  ## 
  ## For additional information about resource structure and identification,
  ## see [Resource Names](/apis/design/resource_names).
  ## 
  let valid = call_598123.validator(path, query, header, formData, body)
  let scheme = call_598123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598123.url(scheme.get, call_598123.host, call_598123.base,
                         call_598123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598123, url, valid)

proc call*(call_598124: Call_CloudresourcemanagerProjectsGetIamPolicy_598107;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsGetIamPolicy
  ## Returns the IAM access control policy for the specified Project.
  ## Permission is denied if the policy or the resource does not exist.
  ## 
  ## For additional information about resource structure and identification,
  ## see [Resource Names](/apis/design/resource_names).
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598125 = newJObject()
  var query_598126 = newJObject()
  var body_598127 = newJObject()
  add(query_598126, "upload_protocol", newJString(uploadProtocol))
  add(query_598126, "fields", newJString(fields))
  add(query_598126, "quotaUser", newJString(quotaUser))
  add(query_598126, "alt", newJString(alt))
  add(query_598126, "oauth_token", newJString(oauthToken))
  add(query_598126, "callback", newJString(callback))
  add(query_598126, "access_token", newJString(accessToken))
  add(query_598126, "uploadType", newJString(uploadType))
  add(query_598126, "key", newJString(key))
  add(query_598126, "$.xgafv", newJString(Xgafv))
  add(path_598125, "resource", newJString(resource))
  if body != nil:
    body_598127 = body
  add(query_598126, "prettyPrint", newJBool(prettyPrint))
  result = call_598124.call(path_598125, query_598126, nil, nil, body_598127)

var cloudresourcemanagerProjectsGetIamPolicy* = Call_CloudresourcemanagerProjectsGetIamPolicy_598107(
    name: "cloudresourcemanagerProjectsGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/projects/{resource}:getIamPolicy",
    validator: validate_CloudresourcemanagerProjectsGetIamPolicy_598108,
    base: "/", url: url_CloudresourcemanagerProjectsGetIamPolicy_598109,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsSetIamPolicy_598128 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerProjectsSetIamPolicy_598130(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsSetIamPolicy_598129(path: JsonNode;
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
  ## + Invitations to grant the owner role cannot be sent using
  ## `setIamPolicy()`; they must be sent only using the Cloud Platform Console.
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
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598131 = path.getOrDefault("resource")
  valid_598131 = validateParameter(valid_598131, JString, required = true,
                                 default = nil)
  if valid_598131 != nil:
    section.add "resource", valid_598131
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
  var valid_598132 = query.getOrDefault("upload_protocol")
  valid_598132 = validateParameter(valid_598132, JString, required = false,
                                 default = nil)
  if valid_598132 != nil:
    section.add "upload_protocol", valid_598132
  var valid_598133 = query.getOrDefault("fields")
  valid_598133 = validateParameter(valid_598133, JString, required = false,
                                 default = nil)
  if valid_598133 != nil:
    section.add "fields", valid_598133
  var valid_598134 = query.getOrDefault("quotaUser")
  valid_598134 = validateParameter(valid_598134, JString, required = false,
                                 default = nil)
  if valid_598134 != nil:
    section.add "quotaUser", valid_598134
  var valid_598135 = query.getOrDefault("alt")
  valid_598135 = validateParameter(valid_598135, JString, required = false,
                                 default = newJString("json"))
  if valid_598135 != nil:
    section.add "alt", valid_598135
  var valid_598136 = query.getOrDefault("oauth_token")
  valid_598136 = validateParameter(valid_598136, JString, required = false,
                                 default = nil)
  if valid_598136 != nil:
    section.add "oauth_token", valid_598136
  var valid_598137 = query.getOrDefault("callback")
  valid_598137 = validateParameter(valid_598137, JString, required = false,
                                 default = nil)
  if valid_598137 != nil:
    section.add "callback", valid_598137
  var valid_598138 = query.getOrDefault("access_token")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = nil)
  if valid_598138 != nil:
    section.add "access_token", valid_598138
  var valid_598139 = query.getOrDefault("uploadType")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "uploadType", valid_598139
  var valid_598140 = query.getOrDefault("key")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = nil)
  if valid_598140 != nil:
    section.add "key", valid_598140
  var valid_598141 = query.getOrDefault("$.xgafv")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = newJString("1"))
  if valid_598141 != nil:
    section.add "$.xgafv", valid_598141
  var valid_598142 = query.getOrDefault("prettyPrint")
  valid_598142 = validateParameter(valid_598142, JBool, required = false,
                                 default = newJBool(true))
  if valid_598142 != nil:
    section.add "prettyPrint", valid_598142
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

proc call*(call_598144: Call_CloudresourcemanagerProjectsSetIamPolicy_598128;
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
  ## + Invitations to grant the owner role cannot be sent using
  ## `setIamPolicy()`; they must be sent only using the Cloud Platform Console.
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
  let valid = call_598144.validator(path, query, header, formData, body)
  let scheme = call_598144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598144.url(scheme.get, call_598144.host, call_598144.base,
                         call_598144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598144, url, valid)

proc call*(call_598145: Call_CloudresourcemanagerProjectsSetIamPolicy_598128;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ## + Invitations to grant the owner role cannot be sent using
  ## `setIamPolicy()`; they must be sent only using the Cloud Platform Console.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598146 = newJObject()
  var query_598147 = newJObject()
  var body_598148 = newJObject()
  add(query_598147, "upload_protocol", newJString(uploadProtocol))
  add(query_598147, "fields", newJString(fields))
  add(query_598147, "quotaUser", newJString(quotaUser))
  add(query_598147, "alt", newJString(alt))
  add(query_598147, "oauth_token", newJString(oauthToken))
  add(query_598147, "callback", newJString(callback))
  add(query_598147, "access_token", newJString(accessToken))
  add(query_598147, "uploadType", newJString(uploadType))
  add(query_598147, "key", newJString(key))
  add(query_598147, "$.xgafv", newJString(Xgafv))
  add(path_598146, "resource", newJString(resource))
  if body != nil:
    body_598148 = body
  add(query_598147, "prettyPrint", newJBool(prettyPrint))
  result = call_598145.call(path_598146, query_598147, nil, nil, body_598148)

var cloudresourcemanagerProjectsSetIamPolicy* = Call_CloudresourcemanagerProjectsSetIamPolicy_598128(
    name: "cloudresourcemanagerProjectsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/projects/{resource}:setIamPolicy",
    validator: validate_CloudresourcemanagerProjectsSetIamPolicy_598129,
    base: "/", url: url_CloudresourcemanagerProjectsSetIamPolicy_598130,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsTestIamPermissions_598149 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerProjectsTestIamPermissions_598151(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsTestIamPermissions_598150(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598152 = path.getOrDefault("resource")
  valid_598152 = validateParameter(valid_598152, JString, required = true,
                                 default = nil)
  if valid_598152 != nil:
    section.add "resource", valid_598152
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
  var valid_598153 = query.getOrDefault("upload_protocol")
  valid_598153 = validateParameter(valid_598153, JString, required = false,
                                 default = nil)
  if valid_598153 != nil:
    section.add "upload_protocol", valid_598153
  var valid_598154 = query.getOrDefault("fields")
  valid_598154 = validateParameter(valid_598154, JString, required = false,
                                 default = nil)
  if valid_598154 != nil:
    section.add "fields", valid_598154
  var valid_598155 = query.getOrDefault("quotaUser")
  valid_598155 = validateParameter(valid_598155, JString, required = false,
                                 default = nil)
  if valid_598155 != nil:
    section.add "quotaUser", valid_598155
  var valid_598156 = query.getOrDefault("alt")
  valid_598156 = validateParameter(valid_598156, JString, required = false,
                                 default = newJString("json"))
  if valid_598156 != nil:
    section.add "alt", valid_598156
  var valid_598157 = query.getOrDefault("oauth_token")
  valid_598157 = validateParameter(valid_598157, JString, required = false,
                                 default = nil)
  if valid_598157 != nil:
    section.add "oauth_token", valid_598157
  var valid_598158 = query.getOrDefault("callback")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = nil)
  if valid_598158 != nil:
    section.add "callback", valid_598158
  var valid_598159 = query.getOrDefault("access_token")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = nil)
  if valid_598159 != nil:
    section.add "access_token", valid_598159
  var valid_598160 = query.getOrDefault("uploadType")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = nil)
  if valid_598160 != nil:
    section.add "uploadType", valid_598160
  var valid_598161 = query.getOrDefault("key")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = nil)
  if valid_598161 != nil:
    section.add "key", valid_598161
  var valid_598162 = query.getOrDefault("$.xgafv")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = newJString("1"))
  if valid_598162 != nil:
    section.add "$.xgafv", valid_598162
  var valid_598163 = query.getOrDefault("prettyPrint")
  valid_598163 = validateParameter(valid_598163, JBool, required = false,
                                 default = newJBool(true))
  if valid_598163 != nil:
    section.add "prettyPrint", valid_598163
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

proc call*(call_598165: Call_CloudresourcemanagerProjectsTestIamPermissions_598149;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  let valid = call_598165.validator(path, query, header, formData, body)
  let scheme = call_598165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598165.url(scheme.get, call_598165.host, call_598165.base,
                         call_598165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598165, url, valid)

proc call*(call_598166: Call_CloudresourcemanagerProjectsTestIamPermissions_598149;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsTestIamPermissions
  ## Returns permissions that a caller has on the specified Project.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598167 = newJObject()
  var query_598168 = newJObject()
  var body_598169 = newJObject()
  add(query_598168, "upload_protocol", newJString(uploadProtocol))
  add(query_598168, "fields", newJString(fields))
  add(query_598168, "quotaUser", newJString(quotaUser))
  add(query_598168, "alt", newJString(alt))
  add(query_598168, "oauth_token", newJString(oauthToken))
  add(query_598168, "callback", newJString(callback))
  add(query_598168, "access_token", newJString(accessToken))
  add(query_598168, "uploadType", newJString(uploadType))
  add(query_598168, "key", newJString(key))
  add(query_598168, "$.xgafv", newJString(Xgafv))
  add(path_598167, "resource", newJString(resource))
  if body != nil:
    body_598169 = body
  add(query_598168, "prettyPrint", newJBool(prettyPrint))
  result = call_598166.call(path_598167, query_598168, nil, nil, body_598169)

var cloudresourcemanagerProjectsTestIamPermissions* = Call_CloudresourcemanagerProjectsTestIamPermissions_598149(
    name: "cloudresourcemanagerProjectsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/projects/{resource}:testIamPermissions",
    validator: validate_CloudresourcemanagerProjectsTestIamPermissions_598150,
    base: "/", url: url_CloudresourcemanagerProjectsTestIamPermissions_598151,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsUpdate_598190 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerOrganizationsUpdate_598192(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsUpdate_598191(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an Organization resource identified by the specified resource name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Output only. The resource name of the organization. This is the
  ## organization's relative path in the API. Its format is
  ## "organizations/[organization_id]". For example, "organizations/1234".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_598193 = path.getOrDefault("name")
  valid_598193 = validateParameter(valid_598193, JString, required = true,
                                 default = nil)
  if valid_598193 != nil:
    section.add "name", valid_598193
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
  var valid_598194 = query.getOrDefault("upload_protocol")
  valid_598194 = validateParameter(valid_598194, JString, required = false,
                                 default = nil)
  if valid_598194 != nil:
    section.add "upload_protocol", valid_598194
  var valid_598195 = query.getOrDefault("fields")
  valid_598195 = validateParameter(valid_598195, JString, required = false,
                                 default = nil)
  if valid_598195 != nil:
    section.add "fields", valid_598195
  var valid_598196 = query.getOrDefault("quotaUser")
  valid_598196 = validateParameter(valid_598196, JString, required = false,
                                 default = nil)
  if valid_598196 != nil:
    section.add "quotaUser", valid_598196
  var valid_598197 = query.getOrDefault("alt")
  valid_598197 = validateParameter(valid_598197, JString, required = false,
                                 default = newJString("json"))
  if valid_598197 != nil:
    section.add "alt", valid_598197
  var valid_598198 = query.getOrDefault("oauth_token")
  valid_598198 = validateParameter(valid_598198, JString, required = false,
                                 default = nil)
  if valid_598198 != nil:
    section.add "oauth_token", valid_598198
  var valid_598199 = query.getOrDefault("callback")
  valid_598199 = validateParameter(valid_598199, JString, required = false,
                                 default = nil)
  if valid_598199 != nil:
    section.add "callback", valid_598199
  var valid_598200 = query.getOrDefault("access_token")
  valid_598200 = validateParameter(valid_598200, JString, required = false,
                                 default = nil)
  if valid_598200 != nil:
    section.add "access_token", valid_598200
  var valid_598201 = query.getOrDefault("uploadType")
  valid_598201 = validateParameter(valid_598201, JString, required = false,
                                 default = nil)
  if valid_598201 != nil:
    section.add "uploadType", valid_598201
  var valid_598202 = query.getOrDefault("key")
  valid_598202 = validateParameter(valid_598202, JString, required = false,
                                 default = nil)
  if valid_598202 != nil:
    section.add "key", valid_598202
  var valid_598203 = query.getOrDefault("$.xgafv")
  valid_598203 = validateParameter(valid_598203, JString, required = false,
                                 default = newJString("1"))
  if valid_598203 != nil:
    section.add "$.xgafv", valid_598203
  var valid_598204 = query.getOrDefault("prettyPrint")
  valid_598204 = validateParameter(valid_598204, JBool, required = false,
                                 default = newJBool(true))
  if valid_598204 != nil:
    section.add "prettyPrint", valid_598204
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

proc call*(call_598206: Call_CloudresourcemanagerOrganizationsUpdate_598190;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an Organization resource identified by the specified resource name.
  ## 
  let valid = call_598206.validator(path, query, header, formData, body)
  let scheme = call_598206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598206.url(scheme.get, call_598206.host, call_598206.base,
                         call_598206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598206, url, valid)

proc call*(call_598207: Call_CloudresourcemanagerOrganizationsUpdate_598190;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsUpdate
  ## Updates an Organization resource identified by the specified resource name.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Output only. The resource name of the organization. This is the
  ## organization's relative path in the API. Its format is
  ## "organizations/[organization_id]". For example, "organizations/1234".
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
  var path_598208 = newJObject()
  var query_598209 = newJObject()
  var body_598210 = newJObject()
  add(query_598209, "upload_protocol", newJString(uploadProtocol))
  add(query_598209, "fields", newJString(fields))
  add(query_598209, "quotaUser", newJString(quotaUser))
  add(path_598208, "name", newJString(name))
  add(query_598209, "alt", newJString(alt))
  add(query_598209, "oauth_token", newJString(oauthToken))
  add(query_598209, "callback", newJString(callback))
  add(query_598209, "access_token", newJString(accessToken))
  add(query_598209, "uploadType", newJString(uploadType))
  add(query_598209, "key", newJString(key))
  add(query_598209, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598210 = body
  add(query_598209, "prettyPrint", newJBool(prettyPrint))
  result = call_598207.call(path_598208, query_598209, nil, nil, body_598210)

var cloudresourcemanagerOrganizationsUpdate* = Call_CloudresourcemanagerOrganizationsUpdate_598190(
    name: "cloudresourcemanagerOrganizationsUpdate", meth: HttpMethod.HttpPut,
    host: "cloudresourcemanager.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudresourcemanagerOrganizationsUpdate_598191, base: "/",
    url: url_CloudresourcemanagerOrganizationsUpdate_598192,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsGet_598170 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerOrganizationsGet_598172(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsGet_598171(path: JsonNode;
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
  var valid_598173 = path.getOrDefault("name")
  valid_598173 = validateParameter(valid_598173, JString, required = true,
                                 default = nil)
  if valid_598173 != nil:
    section.add "name", valid_598173
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
  ##   organizationId: JString
  ##                 : The id of the Organization resource to fetch.
  ## This field is deprecated and will be removed in v1. Use name instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598174 = query.getOrDefault("upload_protocol")
  valid_598174 = validateParameter(valid_598174, JString, required = false,
                                 default = nil)
  if valid_598174 != nil:
    section.add "upload_protocol", valid_598174
  var valid_598175 = query.getOrDefault("fields")
  valid_598175 = validateParameter(valid_598175, JString, required = false,
                                 default = nil)
  if valid_598175 != nil:
    section.add "fields", valid_598175
  var valid_598176 = query.getOrDefault("quotaUser")
  valid_598176 = validateParameter(valid_598176, JString, required = false,
                                 default = nil)
  if valid_598176 != nil:
    section.add "quotaUser", valid_598176
  var valid_598177 = query.getOrDefault("alt")
  valid_598177 = validateParameter(valid_598177, JString, required = false,
                                 default = newJString("json"))
  if valid_598177 != nil:
    section.add "alt", valid_598177
  var valid_598178 = query.getOrDefault("oauth_token")
  valid_598178 = validateParameter(valid_598178, JString, required = false,
                                 default = nil)
  if valid_598178 != nil:
    section.add "oauth_token", valid_598178
  var valid_598179 = query.getOrDefault("callback")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = nil)
  if valid_598179 != nil:
    section.add "callback", valid_598179
  var valid_598180 = query.getOrDefault("access_token")
  valid_598180 = validateParameter(valid_598180, JString, required = false,
                                 default = nil)
  if valid_598180 != nil:
    section.add "access_token", valid_598180
  var valid_598181 = query.getOrDefault("uploadType")
  valid_598181 = validateParameter(valid_598181, JString, required = false,
                                 default = nil)
  if valid_598181 != nil:
    section.add "uploadType", valid_598181
  var valid_598182 = query.getOrDefault("organizationId")
  valid_598182 = validateParameter(valid_598182, JString, required = false,
                                 default = nil)
  if valid_598182 != nil:
    section.add "organizationId", valid_598182
  var valid_598183 = query.getOrDefault("key")
  valid_598183 = validateParameter(valid_598183, JString, required = false,
                                 default = nil)
  if valid_598183 != nil:
    section.add "key", valid_598183
  var valid_598184 = query.getOrDefault("$.xgafv")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = newJString("1"))
  if valid_598184 != nil:
    section.add "$.xgafv", valid_598184
  var valid_598185 = query.getOrDefault("prettyPrint")
  valid_598185 = validateParameter(valid_598185, JBool, required = false,
                                 default = newJBool(true))
  if valid_598185 != nil:
    section.add "prettyPrint", valid_598185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598186: Call_CloudresourcemanagerOrganizationsGet_598170;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches an Organization resource identified by the specified resource name.
  ## 
  let valid = call_598186.validator(path, query, header, formData, body)
  let scheme = call_598186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598186.url(scheme.get, call_598186.host, call_598186.base,
                         call_598186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598186, url, valid)

proc call*(call_598187: Call_CloudresourcemanagerOrganizationsGet_598170;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          organizationId: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsGet
  ## Fetches an Organization resource identified by the specified resource name.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the Organization to fetch. This is the organization's
  ## relative path in the API, formatted as "organizations/[organizationId]".
  ## For example, "organizations/1234".
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
  ##   organizationId: string
  ##                 : The id of the Organization resource to fetch.
  ## This field is deprecated and will be removed in v1. Use name instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598188 = newJObject()
  var query_598189 = newJObject()
  add(query_598189, "upload_protocol", newJString(uploadProtocol))
  add(query_598189, "fields", newJString(fields))
  add(query_598189, "quotaUser", newJString(quotaUser))
  add(path_598188, "name", newJString(name))
  add(query_598189, "alt", newJString(alt))
  add(query_598189, "oauth_token", newJString(oauthToken))
  add(query_598189, "callback", newJString(callback))
  add(query_598189, "access_token", newJString(accessToken))
  add(query_598189, "uploadType", newJString(uploadType))
  add(query_598189, "organizationId", newJString(organizationId))
  add(query_598189, "key", newJString(key))
  add(query_598189, "$.xgafv", newJString(Xgafv))
  add(query_598189, "prettyPrint", newJBool(prettyPrint))
  result = call_598187.call(path_598188, query_598189, nil, nil, nil)

var cloudresourcemanagerOrganizationsGet* = Call_CloudresourcemanagerOrganizationsGet_598170(
    name: "cloudresourcemanagerOrganizationsGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudresourcemanagerOrganizationsGet_598171, base: "/",
    url: url_CloudresourcemanagerOrganizationsGet_598172, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsGetIamPolicy_598211 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerOrganizationsGetIamPolicy_598213(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsGetIamPolicy_598212(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the access control policy for an Organization resource. May be empty
  ## if no such policy or resource exists. The `resource` field should be the
  ## organization's resource name, e.g. "organizations/123".
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598214 = path.getOrDefault("resource")
  valid_598214 = validateParameter(valid_598214, JString, required = true,
                                 default = nil)
  if valid_598214 != nil:
    section.add "resource", valid_598214
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
  var valid_598215 = query.getOrDefault("upload_protocol")
  valid_598215 = validateParameter(valid_598215, JString, required = false,
                                 default = nil)
  if valid_598215 != nil:
    section.add "upload_protocol", valid_598215
  var valid_598216 = query.getOrDefault("fields")
  valid_598216 = validateParameter(valid_598216, JString, required = false,
                                 default = nil)
  if valid_598216 != nil:
    section.add "fields", valid_598216
  var valid_598217 = query.getOrDefault("quotaUser")
  valid_598217 = validateParameter(valid_598217, JString, required = false,
                                 default = nil)
  if valid_598217 != nil:
    section.add "quotaUser", valid_598217
  var valid_598218 = query.getOrDefault("alt")
  valid_598218 = validateParameter(valid_598218, JString, required = false,
                                 default = newJString("json"))
  if valid_598218 != nil:
    section.add "alt", valid_598218
  var valid_598219 = query.getOrDefault("oauth_token")
  valid_598219 = validateParameter(valid_598219, JString, required = false,
                                 default = nil)
  if valid_598219 != nil:
    section.add "oauth_token", valid_598219
  var valid_598220 = query.getOrDefault("callback")
  valid_598220 = validateParameter(valid_598220, JString, required = false,
                                 default = nil)
  if valid_598220 != nil:
    section.add "callback", valid_598220
  var valid_598221 = query.getOrDefault("access_token")
  valid_598221 = validateParameter(valid_598221, JString, required = false,
                                 default = nil)
  if valid_598221 != nil:
    section.add "access_token", valid_598221
  var valid_598222 = query.getOrDefault("uploadType")
  valid_598222 = validateParameter(valid_598222, JString, required = false,
                                 default = nil)
  if valid_598222 != nil:
    section.add "uploadType", valid_598222
  var valid_598223 = query.getOrDefault("key")
  valid_598223 = validateParameter(valid_598223, JString, required = false,
                                 default = nil)
  if valid_598223 != nil:
    section.add "key", valid_598223
  var valid_598224 = query.getOrDefault("$.xgafv")
  valid_598224 = validateParameter(valid_598224, JString, required = false,
                                 default = newJString("1"))
  if valid_598224 != nil:
    section.add "$.xgafv", valid_598224
  var valid_598225 = query.getOrDefault("prettyPrint")
  valid_598225 = validateParameter(valid_598225, JBool, required = false,
                                 default = newJBool(true))
  if valid_598225 != nil:
    section.add "prettyPrint", valid_598225
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

proc call*(call_598227: Call_CloudresourcemanagerOrganizationsGetIamPolicy_598211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for an Organization resource. May be empty
  ## if no such policy or resource exists. The `resource` field should be the
  ## organization's resource name, e.g. "organizations/123".
  ## 
  let valid = call_598227.validator(path, query, header, formData, body)
  let scheme = call_598227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598227.url(scheme.get, call_598227.host, call_598227.base,
                         call_598227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598227, url, valid)

proc call*(call_598228: Call_CloudresourcemanagerOrganizationsGetIamPolicy_598211;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsGetIamPolicy
  ## Gets the access control policy for an Organization resource. May be empty
  ## if no such policy or resource exists. The `resource` field should be the
  ## organization's resource name, e.g. "organizations/123".
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598229 = newJObject()
  var query_598230 = newJObject()
  var body_598231 = newJObject()
  add(query_598230, "upload_protocol", newJString(uploadProtocol))
  add(query_598230, "fields", newJString(fields))
  add(query_598230, "quotaUser", newJString(quotaUser))
  add(query_598230, "alt", newJString(alt))
  add(query_598230, "oauth_token", newJString(oauthToken))
  add(query_598230, "callback", newJString(callback))
  add(query_598230, "access_token", newJString(accessToken))
  add(query_598230, "uploadType", newJString(uploadType))
  add(query_598230, "key", newJString(key))
  add(query_598230, "$.xgafv", newJString(Xgafv))
  add(path_598229, "resource", newJString(resource))
  if body != nil:
    body_598231 = body
  add(query_598230, "prettyPrint", newJBool(prettyPrint))
  result = call_598228.call(path_598229, query_598230, nil, nil, body_598231)

var cloudresourcemanagerOrganizationsGetIamPolicy* = Call_CloudresourcemanagerOrganizationsGetIamPolicy_598211(
    name: "cloudresourcemanagerOrganizationsGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_CloudresourcemanagerOrganizationsGetIamPolicy_598212,
    base: "/", url: url_CloudresourcemanagerOrganizationsGetIamPolicy_598213,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsSetIamPolicy_598232 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerOrganizationsSetIamPolicy_598234(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsSetIamPolicy_598233(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the access control policy on an Organization resource. Replaces any
  ## existing policy. The `resource` field should be the organization's resource
  ## name, e.g. "organizations/123".
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598235 = path.getOrDefault("resource")
  valid_598235 = validateParameter(valid_598235, JString, required = true,
                                 default = nil)
  if valid_598235 != nil:
    section.add "resource", valid_598235
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
  var valid_598236 = query.getOrDefault("upload_protocol")
  valid_598236 = validateParameter(valid_598236, JString, required = false,
                                 default = nil)
  if valid_598236 != nil:
    section.add "upload_protocol", valid_598236
  var valid_598237 = query.getOrDefault("fields")
  valid_598237 = validateParameter(valid_598237, JString, required = false,
                                 default = nil)
  if valid_598237 != nil:
    section.add "fields", valid_598237
  var valid_598238 = query.getOrDefault("quotaUser")
  valid_598238 = validateParameter(valid_598238, JString, required = false,
                                 default = nil)
  if valid_598238 != nil:
    section.add "quotaUser", valid_598238
  var valid_598239 = query.getOrDefault("alt")
  valid_598239 = validateParameter(valid_598239, JString, required = false,
                                 default = newJString("json"))
  if valid_598239 != nil:
    section.add "alt", valid_598239
  var valid_598240 = query.getOrDefault("oauth_token")
  valid_598240 = validateParameter(valid_598240, JString, required = false,
                                 default = nil)
  if valid_598240 != nil:
    section.add "oauth_token", valid_598240
  var valid_598241 = query.getOrDefault("callback")
  valid_598241 = validateParameter(valid_598241, JString, required = false,
                                 default = nil)
  if valid_598241 != nil:
    section.add "callback", valid_598241
  var valid_598242 = query.getOrDefault("access_token")
  valid_598242 = validateParameter(valid_598242, JString, required = false,
                                 default = nil)
  if valid_598242 != nil:
    section.add "access_token", valid_598242
  var valid_598243 = query.getOrDefault("uploadType")
  valid_598243 = validateParameter(valid_598243, JString, required = false,
                                 default = nil)
  if valid_598243 != nil:
    section.add "uploadType", valid_598243
  var valid_598244 = query.getOrDefault("key")
  valid_598244 = validateParameter(valid_598244, JString, required = false,
                                 default = nil)
  if valid_598244 != nil:
    section.add "key", valid_598244
  var valid_598245 = query.getOrDefault("$.xgafv")
  valid_598245 = validateParameter(valid_598245, JString, required = false,
                                 default = newJString("1"))
  if valid_598245 != nil:
    section.add "$.xgafv", valid_598245
  var valid_598246 = query.getOrDefault("prettyPrint")
  valid_598246 = validateParameter(valid_598246, JBool, required = false,
                                 default = newJBool(true))
  if valid_598246 != nil:
    section.add "prettyPrint", valid_598246
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

proc call*(call_598248: Call_CloudresourcemanagerOrganizationsSetIamPolicy_598232;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on an Organization resource. Replaces any
  ## existing policy. The `resource` field should be the organization's resource
  ## name, e.g. "organizations/123".
  ## 
  let valid = call_598248.validator(path, query, header, formData, body)
  let scheme = call_598248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598248.url(scheme.get, call_598248.host, call_598248.base,
                         call_598248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598248, url, valid)

proc call*(call_598249: Call_CloudresourcemanagerOrganizationsSetIamPolicy_598232;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsSetIamPolicy
  ## Sets the access control policy on an Organization resource. Replaces any
  ## existing policy. The `resource` field should be the organization's resource
  ## name, e.g. "organizations/123".
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598250 = newJObject()
  var query_598251 = newJObject()
  var body_598252 = newJObject()
  add(query_598251, "upload_protocol", newJString(uploadProtocol))
  add(query_598251, "fields", newJString(fields))
  add(query_598251, "quotaUser", newJString(quotaUser))
  add(query_598251, "alt", newJString(alt))
  add(query_598251, "oauth_token", newJString(oauthToken))
  add(query_598251, "callback", newJString(callback))
  add(query_598251, "access_token", newJString(accessToken))
  add(query_598251, "uploadType", newJString(uploadType))
  add(query_598251, "key", newJString(key))
  add(query_598251, "$.xgafv", newJString(Xgafv))
  add(path_598250, "resource", newJString(resource))
  if body != nil:
    body_598252 = body
  add(query_598251, "prettyPrint", newJBool(prettyPrint))
  result = call_598249.call(path_598250, query_598251, nil, nil, body_598252)

var cloudresourcemanagerOrganizationsSetIamPolicy* = Call_CloudresourcemanagerOrganizationsSetIamPolicy_598232(
    name: "cloudresourcemanagerOrganizationsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_CloudresourcemanagerOrganizationsSetIamPolicy_598233,
    base: "/", url: url_CloudresourcemanagerOrganizationsSetIamPolicy_598234,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsTestIamPermissions_598253 = ref object of OpenApiRestCall_597408
proc url_CloudresourcemanagerOrganizationsTestIamPermissions_598255(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsTestIamPermissions_598254(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified Organization.
  ## The `resource` field should be the organization's resource name,
  ## e.g. "organizations/123".
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598256 = path.getOrDefault("resource")
  valid_598256 = validateParameter(valid_598256, JString, required = true,
                                 default = nil)
  if valid_598256 != nil:
    section.add "resource", valid_598256
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
  var valid_598257 = query.getOrDefault("upload_protocol")
  valid_598257 = validateParameter(valid_598257, JString, required = false,
                                 default = nil)
  if valid_598257 != nil:
    section.add "upload_protocol", valid_598257
  var valid_598258 = query.getOrDefault("fields")
  valid_598258 = validateParameter(valid_598258, JString, required = false,
                                 default = nil)
  if valid_598258 != nil:
    section.add "fields", valid_598258
  var valid_598259 = query.getOrDefault("quotaUser")
  valid_598259 = validateParameter(valid_598259, JString, required = false,
                                 default = nil)
  if valid_598259 != nil:
    section.add "quotaUser", valid_598259
  var valid_598260 = query.getOrDefault("alt")
  valid_598260 = validateParameter(valid_598260, JString, required = false,
                                 default = newJString("json"))
  if valid_598260 != nil:
    section.add "alt", valid_598260
  var valid_598261 = query.getOrDefault("oauth_token")
  valid_598261 = validateParameter(valid_598261, JString, required = false,
                                 default = nil)
  if valid_598261 != nil:
    section.add "oauth_token", valid_598261
  var valid_598262 = query.getOrDefault("callback")
  valid_598262 = validateParameter(valid_598262, JString, required = false,
                                 default = nil)
  if valid_598262 != nil:
    section.add "callback", valid_598262
  var valid_598263 = query.getOrDefault("access_token")
  valid_598263 = validateParameter(valid_598263, JString, required = false,
                                 default = nil)
  if valid_598263 != nil:
    section.add "access_token", valid_598263
  var valid_598264 = query.getOrDefault("uploadType")
  valid_598264 = validateParameter(valid_598264, JString, required = false,
                                 default = nil)
  if valid_598264 != nil:
    section.add "uploadType", valid_598264
  var valid_598265 = query.getOrDefault("key")
  valid_598265 = validateParameter(valid_598265, JString, required = false,
                                 default = nil)
  if valid_598265 != nil:
    section.add "key", valid_598265
  var valid_598266 = query.getOrDefault("$.xgafv")
  valid_598266 = validateParameter(valid_598266, JString, required = false,
                                 default = newJString("1"))
  if valid_598266 != nil:
    section.add "$.xgafv", valid_598266
  var valid_598267 = query.getOrDefault("prettyPrint")
  valid_598267 = validateParameter(valid_598267, JBool, required = false,
                                 default = newJBool(true))
  if valid_598267 != nil:
    section.add "prettyPrint", valid_598267
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

proc call*(call_598269: Call_CloudresourcemanagerOrganizationsTestIamPermissions_598253;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Organization.
  ## The `resource` field should be the organization's resource name,
  ## e.g. "organizations/123".
  ## 
  let valid = call_598269.validator(path, query, header, formData, body)
  let scheme = call_598269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598269.url(scheme.get, call_598269.host, call_598269.base,
                         call_598269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598269, url, valid)

proc call*(call_598270: Call_CloudresourcemanagerOrganizationsTestIamPermissions_598253;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsTestIamPermissions
  ## Returns permissions that a caller has on the specified Organization.
  ## The `resource` field should be the organization's resource name,
  ## e.g. "organizations/123".
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598271 = newJObject()
  var query_598272 = newJObject()
  var body_598273 = newJObject()
  add(query_598272, "upload_protocol", newJString(uploadProtocol))
  add(query_598272, "fields", newJString(fields))
  add(query_598272, "quotaUser", newJString(quotaUser))
  add(query_598272, "alt", newJString(alt))
  add(query_598272, "oauth_token", newJString(oauthToken))
  add(query_598272, "callback", newJString(callback))
  add(query_598272, "access_token", newJString(accessToken))
  add(query_598272, "uploadType", newJString(uploadType))
  add(query_598272, "key", newJString(key))
  add(query_598272, "$.xgafv", newJString(Xgafv))
  add(path_598271, "resource", newJString(resource))
  if body != nil:
    body_598273 = body
  add(query_598272, "prettyPrint", newJBool(prettyPrint))
  result = call_598270.call(path_598271, query_598272, nil, nil, body_598273)

var cloudresourcemanagerOrganizationsTestIamPermissions* = Call_CloudresourcemanagerOrganizationsTestIamPermissions_598253(
    name: "cloudresourcemanagerOrganizationsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions",
    validator: validate_CloudresourcemanagerOrganizationsTestIamPermissions_598254,
    base: "/", url: url_CloudresourcemanagerOrganizationsTestIamPermissions_598255,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
