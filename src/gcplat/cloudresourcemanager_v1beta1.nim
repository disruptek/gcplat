
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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
  gcpServiceName = "cloudresourcemanager"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudresourcemanagerOrganizationsList_588710 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerOrganizationsList_588712(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerOrganizationsList_588711(path: JsonNode;
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
  var valid_588826 = query.getOrDefault("pageToken")
  valid_588826 = validateParameter(valid_588826, JString, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "pageToken", valid_588826
  var valid_588827 = query.getOrDefault("quotaUser")
  valid_588827 = validateParameter(valid_588827, JString, required = false,
                                 default = nil)
  if valid_588827 != nil:
    section.add "quotaUser", valid_588827
  var valid_588841 = query.getOrDefault("alt")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = newJString("json"))
  if valid_588841 != nil:
    section.add "alt", valid_588841
  var valid_588842 = query.getOrDefault("oauth_token")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "oauth_token", valid_588842
  var valid_588843 = query.getOrDefault("callback")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "callback", valid_588843
  var valid_588844 = query.getOrDefault("access_token")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "access_token", valid_588844
  var valid_588845 = query.getOrDefault("uploadType")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "uploadType", valid_588845
  var valid_588846 = query.getOrDefault("key")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = nil)
  if valid_588846 != nil:
    section.add "key", valid_588846
  var valid_588847 = query.getOrDefault("$.xgafv")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = newJString("1"))
  if valid_588847 != nil:
    section.add "$.xgafv", valid_588847
  var valid_588848 = query.getOrDefault("pageSize")
  valid_588848 = validateParameter(valid_588848, JInt, required = false, default = nil)
  if valid_588848 != nil:
    section.add "pageSize", valid_588848
  var valid_588849 = query.getOrDefault("prettyPrint")
  valid_588849 = validateParameter(valid_588849, JBool, required = false,
                                 default = newJBool(true))
  if valid_588849 != nil:
    section.add "prettyPrint", valid_588849
  var valid_588850 = query.getOrDefault("filter")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "filter", valid_588850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588873: Call_CloudresourcemanagerOrganizationsList_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Organization resources that are visible to the user and satisfy
  ## the specified filter. This method returns Organizations in an unspecified
  ## order. New Organizations do not necessarily appear at the end of the list.
  ## 
  let valid = call_588873.validator(path, query, header, formData, body)
  let scheme = call_588873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588873.url(scheme.get, call_588873.host, call_588873.base,
                         call_588873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588873, url, valid)

proc call*(call_588944: Call_CloudresourcemanagerOrganizationsList_588710;
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
  var query_588945 = newJObject()
  add(query_588945, "upload_protocol", newJString(uploadProtocol))
  add(query_588945, "fields", newJString(fields))
  add(query_588945, "pageToken", newJString(pageToken))
  add(query_588945, "quotaUser", newJString(quotaUser))
  add(query_588945, "alt", newJString(alt))
  add(query_588945, "oauth_token", newJString(oauthToken))
  add(query_588945, "callback", newJString(callback))
  add(query_588945, "access_token", newJString(accessToken))
  add(query_588945, "uploadType", newJString(uploadType))
  add(query_588945, "key", newJString(key))
  add(query_588945, "$.xgafv", newJString(Xgafv))
  add(query_588945, "pageSize", newJInt(pageSize))
  add(query_588945, "prettyPrint", newJBool(prettyPrint))
  add(query_588945, "filter", newJString(filter))
  result = call_588944.call(nil, query_588945, nil, nil, nil)

var cloudresourcemanagerOrganizationsList* = Call_CloudresourcemanagerOrganizationsList_588710(
    name: "cloudresourcemanagerOrganizationsList", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1beta1/organizations",
    validator: validate_CloudresourcemanagerOrganizationsList_588711, base: "/",
    url: url_CloudresourcemanagerOrganizationsList_588712, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsCreate_589005 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerProjectsCreate_589007(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerProjectsCreate_589006(path: JsonNode;
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
  var valid_589008 = query.getOrDefault("upload_protocol")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "upload_protocol", valid_589008
  var valid_589009 = query.getOrDefault("fields")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "fields", valid_589009
  var valid_589010 = query.getOrDefault("useLegacyStack")
  valid_589010 = validateParameter(valid_589010, JBool, required = false, default = nil)
  if valid_589010 != nil:
    section.add "useLegacyStack", valid_589010
  var valid_589011 = query.getOrDefault("quotaUser")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "quotaUser", valid_589011
  var valid_589012 = query.getOrDefault("alt")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = newJString("json"))
  if valid_589012 != nil:
    section.add "alt", valid_589012
  var valid_589013 = query.getOrDefault("oauth_token")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "oauth_token", valid_589013
  var valid_589014 = query.getOrDefault("callback")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "callback", valid_589014
  var valid_589015 = query.getOrDefault("access_token")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "access_token", valid_589015
  var valid_589016 = query.getOrDefault("uploadType")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "uploadType", valid_589016
  var valid_589017 = query.getOrDefault("key")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "key", valid_589017
  var valid_589018 = query.getOrDefault("$.xgafv")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = newJString("1"))
  if valid_589018 != nil:
    section.add "$.xgafv", valid_589018
  var valid_589019 = query.getOrDefault("prettyPrint")
  valid_589019 = validateParameter(valid_589019, JBool, required = false,
                                 default = newJBool(true))
  if valid_589019 != nil:
    section.add "prettyPrint", valid_589019
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

proc call*(call_589021: Call_CloudresourcemanagerProjectsCreate_589005;
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
  let valid = call_589021.validator(path, query, header, formData, body)
  let scheme = call_589021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589021.url(scheme.get, call_589021.host, call_589021.base,
                         call_589021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589021, url, valid)

proc call*(call_589022: Call_CloudresourcemanagerProjectsCreate_589005;
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
  var query_589023 = newJObject()
  var body_589024 = newJObject()
  add(query_589023, "upload_protocol", newJString(uploadProtocol))
  add(query_589023, "fields", newJString(fields))
  add(query_589023, "useLegacyStack", newJBool(useLegacyStack))
  add(query_589023, "quotaUser", newJString(quotaUser))
  add(query_589023, "alt", newJString(alt))
  add(query_589023, "oauth_token", newJString(oauthToken))
  add(query_589023, "callback", newJString(callback))
  add(query_589023, "access_token", newJString(accessToken))
  add(query_589023, "uploadType", newJString(uploadType))
  add(query_589023, "key", newJString(key))
  add(query_589023, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589024 = body
  add(query_589023, "prettyPrint", newJBool(prettyPrint))
  result = call_589022.call(nil, query_589023, nil, nil, body_589024)

var cloudresourcemanagerProjectsCreate* = Call_CloudresourcemanagerProjectsCreate_589005(
    name: "cloudresourcemanagerProjectsCreate", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v1beta1/projects",
    validator: validate_CloudresourcemanagerProjectsCreate_589006, base: "/",
    url: url_CloudresourcemanagerProjectsCreate_589007, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsList_588985 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerProjectsList_588987(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerProjectsList_588986(path: JsonNode;
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
  var valid_588988 = query.getOrDefault("upload_protocol")
  valid_588988 = validateParameter(valid_588988, JString, required = false,
                                 default = nil)
  if valid_588988 != nil:
    section.add "upload_protocol", valid_588988
  var valid_588989 = query.getOrDefault("fields")
  valid_588989 = validateParameter(valid_588989, JString, required = false,
                                 default = nil)
  if valid_588989 != nil:
    section.add "fields", valid_588989
  var valid_588990 = query.getOrDefault("pageToken")
  valid_588990 = validateParameter(valid_588990, JString, required = false,
                                 default = nil)
  if valid_588990 != nil:
    section.add "pageToken", valid_588990
  var valid_588991 = query.getOrDefault("quotaUser")
  valid_588991 = validateParameter(valid_588991, JString, required = false,
                                 default = nil)
  if valid_588991 != nil:
    section.add "quotaUser", valid_588991
  var valid_588992 = query.getOrDefault("alt")
  valid_588992 = validateParameter(valid_588992, JString, required = false,
                                 default = newJString("json"))
  if valid_588992 != nil:
    section.add "alt", valid_588992
  var valid_588993 = query.getOrDefault("oauth_token")
  valid_588993 = validateParameter(valid_588993, JString, required = false,
                                 default = nil)
  if valid_588993 != nil:
    section.add "oauth_token", valid_588993
  var valid_588994 = query.getOrDefault("callback")
  valid_588994 = validateParameter(valid_588994, JString, required = false,
                                 default = nil)
  if valid_588994 != nil:
    section.add "callback", valid_588994
  var valid_588995 = query.getOrDefault("access_token")
  valid_588995 = validateParameter(valid_588995, JString, required = false,
                                 default = nil)
  if valid_588995 != nil:
    section.add "access_token", valid_588995
  var valid_588996 = query.getOrDefault("uploadType")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "uploadType", valid_588996
  var valid_588997 = query.getOrDefault("key")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = nil)
  if valid_588997 != nil:
    section.add "key", valid_588997
  var valid_588998 = query.getOrDefault("$.xgafv")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = newJString("1"))
  if valid_588998 != nil:
    section.add "$.xgafv", valid_588998
  var valid_588999 = query.getOrDefault("pageSize")
  valid_588999 = validateParameter(valid_588999, JInt, required = false, default = nil)
  if valid_588999 != nil:
    section.add "pageSize", valid_588999
  var valid_589000 = query.getOrDefault("prettyPrint")
  valid_589000 = validateParameter(valid_589000, JBool, required = false,
                                 default = newJBool(true))
  if valid_589000 != nil:
    section.add "prettyPrint", valid_589000
  var valid_589001 = query.getOrDefault("filter")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "filter", valid_589001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589002: Call_CloudresourcemanagerProjectsList_588985;
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
  let valid = call_589002.validator(path, query, header, formData, body)
  let scheme = call_589002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589002.url(scheme.get, call_589002.host, call_589002.base,
                         call_589002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589002, url, valid)

proc call*(call_589003: Call_CloudresourcemanagerProjectsList_588985;
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
  var query_589004 = newJObject()
  add(query_589004, "upload_protocol", newJString(uploadProtocol))
  add(query_589004, "fields", newJString(fields))
  add(query_589004, "pageToken", newJString(pageToken))
  add(query_589004, "quotaUser", newJString(quotaUser))
  add(query_589004, "alt", newJString(alt))
  add(query_589004, "oauth_token", newJString(oauthToken))
  add(query_589004, "callback", newJString(callback))
  add(query_589004, "access_token", newJString(accessToken))
  add(query_589004, "uploadType", newJString(uploadType))
  add(query_589004, "key", newJString(key))
  add(query_589004, "$.xgafv", newJString(Xgafv))
  add(query_589004, "pageSize", newJInt(pageSize))
  add(query_589004, "prettyPrint", newJBool(prettyPrint))
  add(query_589004, "filter", newJString(filter))
  result = call_589003.call(nil, query_589004, nil, nil, nil)

var cloudresourcemanagerProjectsList* = Call_CloudresourcemanagerProjectsList_588985(
    name: "cloudresourcemanagerProjectsList", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1beta1/projects",
    validator: validate_CloudresourcemanagerProjectsList_588986, base: "/",
    url: url_CloudresourcemanagerProjectsList_588987, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsUpdate_589058 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerProjectsUpdate_589060(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsUpdate_589059(path: JsonNode;
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
  var valid_589061 = path.getOrDefault("projectId")
  valid_589061 = validateParameter(valid_589061, JString, required = true,
                                 default = nil)
  if valid_589061 != nil:
    section.add "projectId", valid_589061
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
  var valid_589062 = query.getOrDefault("upload_protocol")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "upload_protocol", valid_589062
  var valid_589063 = query.getOrDefault("fields")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "fields", valid_589063
  var valid_589064 = query.getOrDefault("quotaUser")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "quotaUser", valid_589064
  var valid_589065 = query.getOrDefault("alt")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = newJString("json"))
  if valid_589065 != nil:
    section.add "alt", valid_589065
  var valid_589066 = query.getOrDefault("oauth_token")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "oauth_token", valid_589066
  var valid_589067 = query.getOrDefault("callback")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "callback", valid_589067
  var valid_589068 = query.getOrDefault("access_token")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "access_token", valid_589068
  var valid_589069 = query.getOrDefault("uploadType")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "uploadType", valid_589069
  var valid_589070 = query.getOrDefault("key")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "key", valid_589070
  var valid_589071 = query.getOrDefault("$.xgafv")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = newJString("1"))
  if valid_589071 != nil:
    section.add "$.xgafv", valid_589071
  var valid_589072 = query.getOrDefault("prettyPrint")
  valid_589072 = validateParameter(valid_589072, JBool, required = false,
                                 default = newJBool(true))
  if valid_589072 != nil:
    section.add "prettyPrint", valid_589072
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

proc call*(call_589074: Call_CloudresourcemanagerProjectsUpdate_589058;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the attributes of the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  let valid = call_589074.validator(path, query, header, formData, body)
  let scheme = call_589074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589074.url(scheme.get, call_589074.host, call_589074.base,
                         call_589074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589074, url, valid)

proc call*(call_589075: Call_CloudresourcemanagerProjectsUpdate_589058;
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
  var path_589076 = newJObject()
  var query_589077 = newJObject()
  var body_589078 = newJObject()
  add(query_589077, "upload_protocol", newJString(uploadProtocol))
  add(query_589077, "fields", newJString(fields))
  add(query_589077, "quotaUser", newJString(quotaUser))
  add(query_589077, "alt", newJString(alt))
  add(query_589077, "oauth_token", newJString(oauthToken))
  add(query_589077, "callback", newJString(callback))
  add(query_589077, "access_token", newJString(accessToken))
  add(query_589077, "uploadType", newJString(uploadType))
  add(query_589077, "key", newJString(key))
  add(path_589076, "projectId", newJString(projectId))
  add(query_589077, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589078 = body
  add(query_589077, "prettyPrint", newJBool(prettyPrint))
  result = call_589075.call(path_589076, query_589077, nil, nil, body_589078)

var cloudresourcemanagerProjectsUpdate* = Call_CloudresourcemanagerProjectsUpdate_589058(
    name: "cloudresourcemanagerProjectsUpdate", meth: HttpMethod.HttpPut,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/projects/{projectId}",
    validator: validate_CloudresourcemanagerProjectsUpdate_589059, base: "/",
    url: url_CloudresourcemanagerProjectsUpdate_589060, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsGet_589025 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerProjectsGet_589027(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsGet_589026(path: JsonNode;
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
  var valid_589042 = path.getOrDefault("projectId")
  valid_589042 = validateParameter(valid_589042, JString, required = true,
                                 default = nil)
  if valid_589042 != nil:
    section.add "projectId", valid_589042
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
  var valid_589043 = query.getOrDefault("upload_protocol")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "upload_protocol", valid_589043
  var valid_589044 = query.getOrDefault("fields")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "fields", valid_589044
  var valid_589045 = query.getOrDefault("quotaUser")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "quotaUser", valid_589045
  var valid_589046 = query.getOrDefault("alt")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = newJString("json"))
  if valid_589046 != nil:
    section.add "alt", valid_589046
  var valid_589047 = query.getOrDefault("oauth_token")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "oauth_token", valid_589047
  var valid_589048 = query.getOrDefault("callback")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "callback", valid_589048
  var valid_589049 = query.getOrDefault("access_token")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "access_token", valid_589049
  var valid_589050 = query.getOrDefault("uploadType")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "uploadType", valid_589050
  var valid_589051 = query.getOrDefault("key")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "key", valid_589051
  var valid_589052 = query.getOrDefault("$.xgafv")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = newJString("1"))
  if valid_589052 != nil:
    section.add "$.xgafv", valid_589052
  var valid_589053 = query.getOrDefault("prettyPrint")
  valid_589053 = validateParameter(valid_589053, JBool, required = false,
                                 default = newJBool(true))
  if valid_589053 != nil:
    section.add "prettyPrint", valid_589053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589054: Call_CloudresourcemanagerProjectsGet_589025;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
  ## 
  let valid = call_589054.validator(path, query, header, formData, body)
  let scheme = call_589054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589054.url(scheme.get, call_589054.host, call_589054.base,
                         call_589054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589054, url, valid)

proc call*(call_589055: Call_CloudresourcemanagerProjectsGet_589025;
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
  var path_589056 = newJObject()
  var query_589057 = newJObject()
  add(query_589057, "upload_protocol", newJString(uploadProtocol))
  add(query_589057, "fields", newJString(fields))
  add(query_589057, "quotaUser", newJString(quotaUser))
  add(query_589057, "alt", newJString(alt))
  add(query_589057, "oauth_token", newJString(oauthToken))
  add(query_589057, "callback", newJString(callback))
  add(query_589057, "access_token", newJString(accessToken))
  add(query_589057, "uploadType", newJString(uploadType))
  add(query_589057, "key", newJString(key))
  add(path_589056, "projectId", newJString(projectId))
  add(query_589057, "$.xgafv", newJString(Xgafv))
  add(query_589057, "prettyPrint", newJBool(prettyPrint))
  result = call_589055.call(path_589056, query_589057, nil, nil, nil)

var cloudresourcemanagerProjectsGet* = Call_CloudresourcemanagerProjectsGet_589025(
    name: "cloudresourcemanagerProjectsGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/projects/{projectId}",
    validator: validate_CloudresourcemanagerProjectsGet_589026, base: "/",
    url: url_CloudresourcemanagerProjectsGet_589027, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsDelete_589079 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerProjectsDelete_589081(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsDelete_589080(path: JsonNode;
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
  var valid_589082 = path.getOrDefault("projectId")
  valid_589082 = validateParameter(valid_589082, JString, required = true,
                                 default = nil)
  if valid_589082 != nil:
    section.add "projectId", valid_589082
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
  var valid_589083 = query.getOrDefault("upload_protocol")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "upload_protocol", valid_589083
  var valid_589084 = query.getOrDefault("fields")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "fields", valid_589084
  var valid_589085 = query.getOrDefault("quotaUser")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "quotaUser", valid_589085
  var valid_589086 = query.getOrDefault("alt")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = newJString("json"))
  if valid_589086 != nil:
    section.add "alt", valid_589086
  var valid_589087 = query.getOrDefault("oauth_token")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "oauth_token", valid_589087
  var valid_589088 = query.getOrDefault("callback")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "callback", valid_589088
  var valid_589089 = query.getOrDefault("access_token")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "access_token", valid_589089
  var valid_589090 = query.getOrDefault("uploadType")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "uploadType", valid_589090
  var valid_589091 = query.getOrDefault("key")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "key", valid_589091
  var valid_589092 = query.getOrDefault("$.xgafv")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = newJString("1"))
  if valid_589092 != nil:
    section.add "$.xgafv", valid_589092
  var valid_589093 = query.getOrDefault("prettyPrint")
  valid_589093 = validateParameter(valid_589093, JBool, required = false,
                                 default = newJBool(true))
  if valid_589093 != nil:
    section.add "prettyPrint", valid_589093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589094: Call_CloudresourcemanagerProjectsDelete_589079;
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
  let valid = call_589094.validator(path, query, header, formData, body)
  let scheme = call_589094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589094.url(scheme.get, call_589094.host, call_589094.base,
                         call_589094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589094, url, valid)

proc call*(call_589095: Call_CloudresourcemanagerProjectsDelete_589079;
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
  var path_589096 = newJObject()
  var query_589097 = newJObject()
  add(query_589097, "upload_protocol", newJString(uploadProtocol))
  add(query_589097, "fields", newJString(fields))
  add(query_589097, "quotaUser", newJString(quotaUser))
  add(query_589097, "alt", newJString(alt))
  add(query_589097, "oauth_token", newJString(oauthToken))
  add(query_589097, "callback", newJString(callback))
  add(query_589097, "access_token", newJString(accessToken))
  add(query_589097, "uploadType", newJString(uploadType))
  add(query_589097, "key", newJString(key))
  add(path_589096, "projectId", newJString(projectId))
  add(query_589097, "$.xgafv", newJString(Xgafv))
  add(query_589097, "prettyPrint", newJBool(prettyPrint))
  result = call_589095.call(path_589096, query_589097, nil, nil, nil)

var cloudresourcemanagerProjectsDelete* = Call_CloudresourcemanagerProjectsDelete_589079(
    name: "cloudresourcemanagerProjectsDelete", meth: HttpMethod.HttpDelete,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/projects/{projectId}",
    validator: validate_CloudresourcemanagerProjectsDelete_589080, base: "/",
    url: url_CloudresourcemanagerProjectsDelete_589081, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsGetAncestry_589098 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerProjectsGetAncestry_589100(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerProjectsGetAncestry_589099(path: JsonNode;
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
  var valid_589101 = path.getOrDefault("projectId")
  valid_589101 = validateParameter(valid_589101, JString, required = true,
                                 default = nil)
  if valid_589101 != nil:
    section.add "projectId", valid_589101
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
  var valid_589102 = query.getOrDefault("upload_protocol")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "upload_protocol", valid_589102
  var valid_589103 = query.getOrDefault("fields")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "fields", valid_589103
  var valid_589104 = query.getOrDefault("quotaUser")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "quotaUser", valid_589104
  var valid_589105 = query.getOrDefault("alt")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = newJString("json"))
  if valid_589105 != nil:
    section.add "alt", valid_589105
  var valid_589106 = query.getOrDefault("oauth_token")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "oauth_token", valid_589106
  var valid_589107 = query.getOrDefault("callback")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "callback", valid_589107
  var valid_589108 = query.getOrDefault("access_token")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "access_token", valid_589108
  var valid_589109 = query.getOrDefault("uploadType")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "uploadType", valid_589109
  var valid_589110 = query.getOrDefault("key")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "key", valid_589110
  var valid_589111 = query.getOrDefault("$.xgafv")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = newJString("1"))
  if valid_589111 != nil:
    section.add "$.xgafv", valid_589111
  var valid_589112 = query.getOrDefault("prettyPrint")
  valid_589112 = validateParameter(valid_589112, JBool, required = false,
                                 default = newJBool(true))
  if valid_589112 != nil:
    section.add "prettyPrint", valid_589112
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

proc call*(call_589114: Call_CloudresourcemanagerProjectsGetAncestry_589098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of ancestors in the resource hierarchy for the Project
  ## identified by the specified `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
  ## 
  let valid = call_589114.validator(path, query, header, formData, body)
  let scheme = call_589114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589114.url(scheme.get, call_589114.host, call_589114.base,
                         call_589114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589114, url, valid)

proc call*(call_589115: Call_CloudresourcemanagerProjectsGetAncestry_589098;
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
  var path_589116 = newJObject()
  var query_589117 = newJObject()
  var body_589118 = newJObject()
  add(query_589117, "upload_protocol", newJString(uploadProtocol))
  add(query_589117, "fields", newJString(fields))
  add(query_589117, "quotaUser", newJString(quotaUser))
  add(query_589117, "alt", newJString(alt))
  add(query_589117, "oauth_token", newJString(oauthToken))
  add(query_589117, "callback", newJString(callback))
  add(query_589117, "access_token", newJString(accessToken))
  add(query_589117, "uploadType", newJString(uploadType))
  add(query_589117, "key", newJString(key))
  add(path_589116, "projectId", newJString(projectId))
  add(query_589117, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589118 = body
  add(query_589117, "prettyPrint", newJBool(prettyPrint))
  result = call_589115.call(path_589116, query_589117, nil, nil, body_589118)

var cloudresourcemanagerProjectsGetAncestry* = Call_CloudresourcemanagerProjectsGetAncestry_589098(
    name: "cloudresourcemanagerProjectsGetAncestry", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/projects/{projectId}:getAncestry",
    validator: validate_CloudresourcemanagerProjectsGetAncestry_589099, base: "/",
    url: url_CloudresourcemanagerProjectsGetAncestry_589100,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsUndelete_589119 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerProjectsUndelete_589121(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerProjectsUndelete_589120(path: JsonNode;
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
  var valid_589122 = path.getOrDefault("projectId")
  valid_589122 = validateParameter(valid_589122, JString, required = true,
                                 default = nil)
  if valid_589122 != nil:
    section.add "projectId", valid_589122
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
  var valid_589123 = query.getOrDefault("upload_protocol")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "upload_protocol", valid_589123
  var valid_589124 = query.getOrDefault("fields")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "fields", valid_589124
  var valid_589125 = query.getOrDefault("quotaUser")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "quotaUser", valid_589125
  var valid_589126 = query.getOrDefault("alt")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = newJString("json"))
  if valid_589126 != nil:
    section.add "alt", valid_589126
  var valid_589127 = query.getOrDefault("oauth_token")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "oauth_token", valid_589127
  var valid_589128 = query.getOrDefault("callback")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "callback", valid_589128
  var valid_589129 = query.getOrDefault("access_token")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "access_token", valid_589129
  var valid_589130 = query.getOrDefault("uploadType")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "uploadType", valid_589130
  var valid_589131 = query.getOrDefault("key")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "key", valid_589131
  var valid_589132 = query.getOrDefault("$.xgafv")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = newJString("1"))
  if valid_589132 != nil:
    section.add "$.xgafv", valid_589132
  var valid_589133 = query.getOrDefault("prettyPrint")
  valid_589133 = validateParameter(valid_589133, JBool, required = false,
                                 default = newJBool(true))
  if valid_589133 != nil:
    section.add "prettyPrint", valid_589133
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

proc call*(call_589135: Call_CloudresourcemanagerProjectsUndelete_589119;
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
  let valid = call_589135.validator(path, query, header, formData, body)
  let scheme = call_589135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589135.url(scheme.get, call_589135.host, call_589135.base,
                         call_589135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589135, url, valid)

proc call*(call_589136: Call_CloudresourcemanagerProjectsUndelete_589119;
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
  var path_589137 = newJObject()
  var query_589138 = newJObject()
  var body_589139 = newJObject()
  add(query_589138, "upload_protocol", newJString(uploadProtocol))
  add(query_589138, "fields", newJString(fields))
  add(query_589138, "quotaUser", newJString(quotaUser))
  add(query_589138, "alt", newJString(alt))
  add(query_589138, "oauth_token", newJString(oauthToken))
  add(query_589138, "callback", newJString(callback))
  add(query_589138, "access_token", newJString(accessToken))
  add(query_589138, "uploadType", newJString(uploadType))
  add(query_589138, "key", newJString(key))
  add(path_589137, "projectId", newJString(projectId))
  add(query_589138, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589139 = body
  add(query_589138, "prettyPrint", newJBool(prettyPrint))
  result = call_589136.call(path_589137, query_589138, nil, nil, body_589139)

var cloudresourcemanagerProjectsUndelete* = Call_CloudresourcemanagerProjectsUndelete_589119(
    name: "cloudresourcemanagerProjectsUndelete", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/projects/{projectId}:undelete",
    validator: validate_CloudresourcemanagerProjectsUndelete_589120, base: "/",
    url: url_CloudresourcemanagerProjectsUndelete_589121, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsGetIamPolicy_589140 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerProjectsGetIamPolicy_589142(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerProjectsGetIamPolicy_589141(path: JsonNode;
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
  var valid_589143 = path.getOrDefault("resource")
  valid_589143 = validateParameter(valid_589143, JString, required = true,
                                 default = nil)
  if valid_589143 != nil:
    section.add "resource", valid_589143
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
  var valid_589144 = query.getOrDefault("upload_protocol")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "upload_protocol", valid_589144
  var valid_589145 = query.getOrDefault("fields")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "fields", valid_589145
  var valid_589146 = query.getOrDefault("quotaUser")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "quotaUser", valid_589146
  var valid_589147 = query.getOrDefault("alt")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = newJString("json"))
  if valid_589147 != nil:
    section.add "alt", valid_589147
  var valid_589148 = query.getOrDefault("oauth_token")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "oauth_token", valid_589148
  var valid_589149 = query.getOrDefault("callback")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "callback", valid_589149
  var valid_589150 = query.getOrDefault("access_token")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "access_token", valid_589150
  var valid_589151 = query.getOrDefault("uploadType")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "uploadType", valid_589151
  var valid_589152 = query.getOrDefault("key")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "key", valid_589152
  var valid_589153 = query.getOrDefault("$.xgafv")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = newJString("1"))
  if valid_589153 != nil:
    section.add "$.xgafv", valid_589153
  var valid_589154 = query.getOrDefault("prettyPrint")
  valid_589154 = validateParameter(valid_589154, JBool, required = false,
                                 default = newJBool(true))
  if valid_589154 != nil:
    section.add "prettyPrint", valid_589154
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

proc call*(call_589156: Call_CloudresourcemanagerProjectsGetIamPolicy_589140;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the IAM access control policy for the specified Project.
  ## Permission is denied if the policy or the resource does not exist.
  ## 
  ## For additional information about resource structure and identification,
  ## see [Resource Names](/apis/design/resource_names).
  ## 
  let valid = call_589156.validator(path, query, header, formData, body)
  let scheme = call_589156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589156.url(scheme.get, call_589156.host, call_589156.base,
                         call_589156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589156, url, valid)

proc call*(call_589157: Call_CloudresourcemanagerProjectsGetIamPolicy_589140;
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
  var path_589158 = newJObject()
  var query_589159 = newJObject()
  var body_589160 = newJObject()
  add(query_589159, "upload_protocol", newJString(uploadProtocol))
  add(query_589159, "fields", newJString(fields))
  add(query_589159, "quotaUser", newJString(quotaUser))
  add(query_589159, "alt", newJString(alt))
  add(query_589159, "oauth_token", newJString(oauthToken))
  add(query_589159, "callback", newJString(callback))
  add(query_589159, "access_token", newJString(accessToken))
  add(query_589159, "uploadType", newJString(uploadType))
  add(query_589159, "key", newJString(key))
  add(query_589159, "$.xgafv", newJString(Xgafv))
  add(path_589158, "resource", newJString(resource))
  if body != nil:
    body_589160 = body
  add(query_589159, "prettyPrint", newJBool(prettyPrint))
  result = call_589157.call(path_589158, query_589159, nil, nil, body_589160)

var cloudresourcemanagerProjectsGetIamPolicy* = Call_CloudresourcemanagerProjectsGetIamPolicy_589140(
    name: "cloudresourcemanagerProjectsGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/projects/{resource}:getIamPolicy",
    validator: validate_CloudresourcemanagerProjectsGetIamPolicy_589141,
    base: "/", url: url_CloudresourcemanagerProjectsGetIamPolicy_589142,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsSetIamPolicy_589161 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerProjectsSetIamPolicy_589163(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerProjectsSetIamPolicy_589162(path: JsonNode;
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
  var valid_589164 = path.getOrDefault("resource")
  valid_589164 = validateParameter(valid_589164, JString, required = true,
                                 default = nil)
  if valid_589164 != nil:
    section.add "resource", valid_589164
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
  var valid_589165 = query.getOrDefault("upload_protocol")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "upload_protocol", valid_589165
  var valid_589166 = query.getOrDefault("fields")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "fields", valid_589166
  var valid_589167 = query.getOrDefault("quotaUser")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "quotaUser", valid_589167
  var valid_589168 = query.getOrDefault("alt")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = newJString("json"))
  if valid_589168 != nil:
    section.add "alt", valid_589168
  var valid_589169 = query.getOrDefault("oauth_token")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "oauth_token", valid_589169
  var valid_589170 = query.getOrDefault("callback")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "callback", valid_589170
  var valid_589171 = query.getOrDefault("access_token")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "access_token", valid_589171
  var valid_589172 = query.getOrDefault("uploadType")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "uploadType", valid_589172
  var valid_589173 = query.getOrDefault("key")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "key", valid_589173
  var valid_589174 = query.getOrDefault("$.xgafv")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = newJString("1"))
  if valid_589174 != nil:
    section.add "$.xgafv", valid_589174
  var valid_589175 = query.getOrDefault("prettyPrint")
  valid_589175 = validateParameter(valid_589175, JBool, required = false,
                                 default = newJBool(true))
  if valid_589175 != nil:
    section.add "prettyPrint", valid_589175
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

proc call*(call_589177: Call_CloudresourcemanagerProjectsSetIamPolicy_589161;
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
  let valid = call_589177.validator(path, query, header, formData, body)
  let scheme = call_589177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589177.url(scheme.get, call_589177.host, call_589177.base,
                         call_589177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589177, url, valid)

proc call*(call_589178: Call_CloudresourcemanagerProjectsSetIamPolicy_589161;
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
  var path_589179 = newJObject()
  var query_589180 = newJObject()
  var body_589181 = newJObject()
  add(query_589180, "upload_protocol", newJString(uploadProtocol))
  add(query_589180, "fields", newJString(fields))
  add(query_589180, "quotaUser", newJString(quotaUser))
  add(query_589180, "alt", newJString(alt))
  add(query_589180, "oauth_token", newJString(oauthToken))
  add(query_589180, "callback", newJString(callback))
  add(query_589180, "access_token", newJString(accessToken))
  add(query_589180, "uploadType", newJString(uploadType))
  add(query_589180, "key", newJString(key))
  add(query_589180, "$.xgafv", newJString(Xgafv))
  add(path_589179, "resource", newJString(resource))
  if body != nil:
    body_589181 = body
  add(query_589180, "prettyPrint", newJBool(prettyPrint))
  result = call_589178.call(path_589179, query_589180, nil, nil, body_589181)

var cloudresourcemanagerProjectsSetIamPolicy* = Call_CloudresourcemanagerProjectsSetIamPolicy_589161(
    name: "cloudresourcemanagerProjectsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/projects/{resource}:setIamPolicy",
    validator: validate_CloudresourcemanagerProjectsSetIamPolicy_589162,
    base: "/", url: url_CloudresourcemanagerProjectsSetIamPolicy_589163,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsTestIamPermissions_589182 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerProjectsTestIamPermissions_589184(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerProjectsTestIamPermissions_589183(
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
  var valid_589185 = path.getOrDefault("resource")
  valid_589185 = validateParameter(valid_589185, JString, required = true,
                                 default = nil)
  if valid_589185 != nil:
    section.add "resource", valid_589185
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
  var valid_589186 = query.getOrDefault("upload_protocol")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "upload_protocol", valid_589186
  var valid_589187 = query.getOrDefault("fields")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "fields", valid_589187
  var valid_589188 = query.getOrDefault("quotaUser")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "quotaUser", valid_589188
  var valid_589189 = query.getOrDefault("alt")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = newJString("json"))
  if valid_589189 != nil:
    section.add "alt", valid_589189
  var valid_589190 = query.getOrDefault("oauth_token")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "oauth_token", valid_589190
  var valid_589191 = query.getOrDefault("callback")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "callback", valid_589191
  var valid_589192 = query.getOrDefault("access_token")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "access_token", valid_589192
  var valid_589193 = query.getOrDefault("uploadType")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "uploadType", valid_589193
  var valid_589194 = query.getOrDefault("key")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "key", valid_589194
  var valid_589195 = query.getOrDefault("$.xgafv")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = newJString("1"))
  if valid_589195 != nil:
    section.add "$.xgafv", valid_589195
  var valid_589196 = query.getOrDefault("prettyPrint")
  valid_589196 = validateParameter(valid_589196, JBool, required = false,
                                 default = newJBool(true))
  if valid_589196 != nil:
    section.add "prettyPrint", valid_589196
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

proc call*(call_589198: Call_CloudresourcemanagerProjectsTestIamPermissions_589182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  let valid = call_589198.validator(path, query, header, formData, body)
  let scheme = call_589198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589198.url(scheme.get, call_589198.host, call_589198.base,
                         call_589198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589198, url, valid)

proc call*(call_589199: Call_CloudresourcemanagerProjectsTestIamPermissions_589182;
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
  var path_589200 = newJObject()
  var query_589201 = newJObject()
  var body_589202 = newJObject()
  add(query_589201, "upload_protocol", newJString(uploadProtocol))
  add(query_589201, "fields", newJString(fields))
  add(query_589201, "quotaUser", newJString(quotaUser))
  add(query_589201, "alt", newJString(alt))
  add(query_589201, "oauth_token", newJString(oauthToken))
  add(query_589201, "callback", newJString(callback))
  add(query_589201, "access_token", newJString(accessToken))
  add(query_589201, "uploadType", newJString(uploadType))
  add(query_589201, "key", newJString(key))
  add(query_589201, "$.xgafv", newJString(Xgafv))
  add(path_589200, "resource", newJString(resource))
  if body != nil:
    body_589202 = body
  add(query_589201, "prettyPrint", newJBool(prettyPrint))
  result = call_589199.call(path_589200, query_589201, nil, nil, body_589202)

var cloudresourcemanagerProjectsTestIamPermissions* = Call_CloudresourcemanagerProjectsTestIamPermissions_589182(
    name: "cloudresourcemanagerProjectsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/projects/{resource}:testIamPermissions",
    validator: validate_CloudresourcemanagerProjectsTestIamPermissions_589183,
    base: "/", url: url_CloudresourcemanagerProjectsTestIamPermissions_589184,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsUpdate_589223 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerOrganizationsUpdate_589225(protocol: Scheme;
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

proc validate_CloudresourcemanagerOrganizationsUpdate_589224(path: JsonNode;
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
  var valid_589226 = path.getOrDefault("name")
  valid_589226 = validateParameter(valid_589226, JString, required = true,
                                 default = nil)
  if valid_589226 != nil:
    section.add "name", valid_589226
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
  var valid_589227 = query.getOrDefault("upload_protocol")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "upload_protocol", valid_589227
  var valid_589228 = query.getOrDefault("fields")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "fields", valid_589228
  var valid_589229 = query.getOrDefault("quotaUser")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "quotaUser", valid_589229
  var valid_589230 = query.getOrDefault("alt")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = newJString("json"))
  if valid_589230 != nil:
    section.add "alt", valid_589230
  var valid_589231 = query.getOrDefault("oauth_token")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "oauth_token", valid_589231
  var valid_589232 = query.getOrDefault("callback")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "callback", valid_589232
  var valid_589233 = query.getOrDefault("access_token")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "access_token", valid_589233
  var valid_589234 = query.getOrDefault("uploadType")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "uploadType", valid_589234
  var valid_589235 = query.getOrDefault("key")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "key", valid_589235
  var valid_589236 = query.getOrDefault("$.xgafv")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = newJString("1"))
  if valid_589236 != nil:
    section.add "$.xgafv", valid_589236
  var valid_589237 = query.getOrDefault("prettyPrint")
  valid_589237 = validateParameter(valid_589237, JBool, required = false,
                                 default = newJBool(true))
  if valid_589237 != nil:
    section.add "prettyPrint", valid_589237
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

proc call*(call_589239: Call_CloudresourcemanagerOrganizationsUpdate_589223;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an Organization resource identified by the specified resource name.
  ## 
  let valid = call_589239.validator(path, query, header, formData, body)
  let scheme = call_589239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589239.url(scheme.get, call_589239.host, call_589239.base,
                         call_589239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589239, url, valid)

proc call*(call_589240: Call_CloudresourcemanagerOrganizationsUpdate_589223;
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
  var path_589241 = newJObject()
  var query_589242 = newJObject()
  var body_589243 = newJObject()
  add(query_589242, "upload_protocol", newJString(uploadProtocol))
  add(query_589242, "fields", newJString(fields))
  add(query_589242, "quotaUser", newJString(quotaUser))
  add(path_589241, "name", newJString(name))
  add(query_589242, "alt", newJString(alt))
  add(query_589242, "oauth_token", newJString(oauthToken))
  add(query_589242, "callback", newJString(callback))
  add(query_589242, "access_token", newJString(accessToken))
  add(query_589242, "uploadType", newJString(uploadType))
  add(query_589242, "key", newJString(key))
  add(query_589242, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589243 = body
  add(query_589242, "prettyPrint", newJBool(prettyPrint))
  result = call_589240.call(path_589241, query_589242, nil, nil, body_589243)

var cloudresourcemanagerOrganizationsUpdate* = Call_CloudresourcemanagerOrganizationsUpdate_589223(
    name: "cloudresourcemanagerOrganizationsUpdate", meth: HttpMethod.HttpPut,
    host: "cloudresourcemanager.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudresourcemanagerOrganizationsUpdate_589224, base: "/",
    url: url_CloudresourcemanagerOrganizationsUpdate_589225,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsGet_589203 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerOrganizationsGet_589205(protocol: Scheme;
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

proc validate_CloudresourcemanagerOrganizationsGet_589204(path: JsonNode;
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
  var valid_589206 = path.getOrDefault("name")
  valid_589206 = validateParameter(valid_589206, JString, required = true,
                                 default = nil)
  if valid_589206 != nil:
    section.add "name", valid_589206
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
  var valid_589207 = query.getOrDefault("upload_protocol")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "upload_protocol", valid_589207
  var valid_589208 = query.getOrDefault("fields")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "fields", valid_589208
  var valid_589209 = query.getOrDefault("quotaUser")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "quotaUser", valid_589209
  var valid_589210 = query.getOrDefault("alt")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = newJString("json"))
  if valid_589210 != nil:
    section.add "alt", valid_589210
  var valid_589211 = query.getOrDefault("oauth_token")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "oauth_token", valid_589211
  var valid_589212 = query.getOrDefault("callback")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "callback", valid_589212
  var valid_589213 = query.getOrDefault("access_token")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "access_token", valid_589213
  var valid_589214 = query.getOrDefault("uploadType")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "uploadType", valid_589214
  var valid_589215 = query.getOrDefault("organizationId")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "organizationId", valid_589215
  var valid_589216 = query.getOrDefault("key")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "key", valid_589216
  var valid_589217 = query.getOrDefault("$.xgafv")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = newJString("1"))
  if valid_589217 != nil:
    section.add "$.xgafv", valid_589217
  var valid_589218 = query.getOrDefault("prettyPrint")
  valid_589218 = validateParameter(valid_589218, JBool, required = false,
                                 default = newJBool(true))
  if valid_589218 != nil:
    section.add "prettyPrint", valid_589218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589219: Call_CloudresourcemanagerOrganizationsGet_589203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches an Organization resource identified by the specified resource name.
  ## 
  let valid = call_589219.validator(path, query, header, formData, body)
  let scheme = call_589219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589219.url(scheme.get, call_589219.host, call_589219.base,
                         call_589219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589219, url, valid)

proc call*(call_589220: Call_CloudresourcemanagerOrganizationsGet_589203;
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
  var path_589221 = newJObject()
  var query_589222 = newJObject()
  add(query_589222, "upload_protocol", newJString(uploadProtocol))
  add(query_589222, "fields", newJString(fields))
  add(query_589222, "quotaUser", newJString(quotaUser))
  add(path_589221, "name", newJString(name))
  add(query_589222, "alt", newJString(alt))
  add(query_589222, "oauth_token", newJString(oauthToken))
  add(query_589222, "callback", newJString(callback))
  add(query_589222, "access_token", newJString(accessToken))
  add(query_589222, "uploadType", newJString(uploadType))
  add(query_589222, "organizationId", newJString(organizationId))
  add(query_589222, "key", newJString(key))
  add(query_589222, "$.xgafv", newJString(Xgafv))
  add(query_589222, "prettyPrint", newJBool(prettyPrint))
  result = call_589220.call(path_589221, query_589222, nil, nil, nil)

var cloudresourcemanagerOrganizationsGet* = Call_CloudresourcemanagerOrganizationsGet_589203(
    name: "cloudresourcemanagerOrganizationsGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudresourcemanagerOrganizationsGet_589204, base: "/",
    url: url_CloudresourcemanagerOrganizationsGet_589205, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsGetIamPolicy_589244 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerOrganizationsGetIamPolicy_589246(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerOrganizationsGetIamPolicy_589245(
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
  var valid_589247 = path.getOrDefault("resource")
  valid_589247 = validateParameter(valid_589247, JString, required = true,
                                 default = nil)
  if valid_589247 != nil:
    section.add "resource", valid_589247
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
  var valid_589248 = query.getOrDefault("upload_protocol")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "upload_protocol", valid_589248
  var valid_589249 = query.getOrDefault("fields")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "fields", valid_589249
  var valid_589250 = query.getOrDefault("quotaUser")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "quotaUser", valid_589250
  var valid_589251 = query.getOrDefault("alt")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = newJString("json"))
  if valid_589251 != nil:
    section.add "alt", valid_589251
  var valid_589252 = query.getOrDefault("oauth_token")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "oauth_token", valid_589252
  var valid_589253 = query.getOrDefault("callback")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "callback", valid_589253
  var valid_589254 = query.getOrDefault("access_token")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "access_token", valid_589254
  var valid_589255 = query.getOrDefault("uploadType")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "uploadType", valid_589255
  var valid_589256 = query.getOrDefault("key")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "key", valid_589256
  var valid_589257 = query.getOrDefault("$.xgafv")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = newJString("1"))
  if valid_589257 != nil:
    section.add "$.xgafv", valid_589257
  var valid_589258 = query.getOrDefault("prettyPrint")
  valid_589258 = validateParameter(valid_589258, JBool, required = false,
                                 default = newJBool(true))
  if valid_589258 != nil:
    section.add "prettyPrint", valid_589258
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

proc call*(call_589260: Call_CloudresourcemanagerOrganizationsGetIamPolicy_589244;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for an Organization resource. May be empty
  ## if no such policy or resource exists. The `resource` field should be the
  ## organization's resource name, e.g. "organizations/123".
  ## 
  let valid = call_589260.validator(path, query, header, formData, body)
  let scheme = call_589260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589260.url(scheme.get, call_589260.host, call_589260.base,
                         call_589260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589260, url, valid)

proc call*(call_589261: Call_CloudresourcemanagerOrganizationsGetIamPolicy_589244;
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
  var path_589262 = newJObject()
  var query_589263 = newJObject()
  var body_589264 = newJObject()
  add(query_589263, "upload_protocol", newJString(uploadProtocol))
  add(query_589263, "fields", newJString(fields))
  add(query_589263, "quotaUser", newJString(quotaUser))
  add(query_589263, "alt", newJString(alt))
  add(query_589263, "oauth_token", newJString(oauthToken))
  add(query_589263, "callback", newJString(callback))
  add(query_589263, "access_token", newJString(accessToken))
  add(query_589263, "uploadType", newJString(uploadType))
  add(query_589263, "key", newJString(key))
  add(query_589263, "$.xgafv", newJString(Xgafv))
  add(path_589262, "resource", newJString(resource))
  if body != nil:
    body_589264 = body
  add(query_589263, "prettyPrint", newJBool(prettyPrint))
  result = call_589261.call(path_589262, query_589263, nil, nil, body_589264)

var cloudresourcemanagerOrganizationsGetIamPolicy* = Call_CloudresourcemanagerOrganizationsGetIamPolicy_589244(
    name: "cloudresourcemanagerOrganizationsGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_CloudresourcemanagerOrganizationsGetIamPolicy_589245,
    base: "/", url: url_CloudresourcemanagerOrganizationsGetIamPolicy_589246,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsSetIamPolicy_589265 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerOrganizationsSetIamPolicy_589267(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerOrganizationsSetIamPolicy_589266(
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
  var valid_589268 = path.getOrDefault("resource")
  valid_589268 = validateParameter(valid_589268, JString, required = true,
                                 default = nil)
  if valid_589268 != nil:
    section.add "resource", valid_589268
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
  var valid_589269 = query.getOrDefault("upload_protocol")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "upload_protocol", valid_589269
  var valid_589270 = query.getOrDefault("fields")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "fields", valid_589270
  var valid_589271 = query.getOrDefault("quotaUser")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "quotaUser", valid_589271
  var valid_589272 = query.getOrDefault("alt")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = newJString("json"))
  if valid_589272 != nil:
    section.add "alt", valid_589272
  var valid_589273 = query.getOrDefault("oauth_token")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "oauth_token", valid_589273
  var valid_589274 = query.getOrDefault("callback")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "callback", valid_589274
  var valid_589275 = query.getOrDefault("access_token")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "access_token", valid_589275
  var valid_589276 = query.getOrDefault("uploadType")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "uploadType", valid_589276
  var valid_589277 = query.getOrDefault("key")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "key", valid_589277
  var valid_589278 = query.getOrDefault("$.xgafv")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = newJString("1"))
  if valid_589278 != nil:
    section.add "$.xgafv", valid_589278
  var valid_589279 = query.getOrDefault("prettyPrint")
  valid_589279 = validateParameter(valid_589279, JBool, required = false,
                                 default = newJBool(true))
  if valid_589279 != nil:
    section.add "prettyPrint", valid_589279
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

proc call*(call_589281: Call_CloudresourcemanagerOrganizationsSetIamPolicy_589265;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on an Organization resource. Replaces any
  ## existing policy. The `resource` field should be the organization's resource
  ## name, e.g. "organizations/123".
  ## 
  let valid = call_589281.validator(path, query, header, formData, body)
  let scheme = call_589281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589281.url(scheme.get, call_589281.host, call_589281.base,
                         call_589281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589281, url, valid)

proc call*(call_589282: Call_CloudresourcemanagerOrganizationsSetIamPolicy_589265;
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
  var path_589283 = newJObject()
  var query_589284 = newJObject()
  var body_589285 = newJObject()
  add(query_589284, "upload_protocol", newJString(uploadProtocol))
  add(query_589284, "fields", newJString(fields))
  add(query_589284, "quotaUser", newJString(quotaUser))
  add(query_589284, "alt", newJString(alt))
  add(query_589284, "oauth_token", newJString(oauthToken))
  add(query_589284, "callback", newJString(callback))
  add(query_589284, "access_token", newJString(accessToken))
  add(query_589284, "uploadType", newJString(uploadType))
  add(query_589284, "key", newJString(key))
  add(query_589284, "$.xgafv", newJString(Xgafv))
  add(path_589283, "resource", newJString(resource))
  if body != nil:
    body_589285 = body
  add(query_589284, "prettyPrint", newJBool(prettyPrint))
  result = call_589282.call(path_589283, query_589284, nil, nil, body_589285)

var cloudresourcemanagerOrganizationsSetIamPolicy* = Call_CloudresourcemanagerOrganizationsSetIamPolicy_589265(
    name: "cloudresourcemanagerOrganizationsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_CloudresourcemanagerOrganizationsSetIamPolicy_589266,
    base: "/", url: url_CloudresourcemanagerOrganizationsSetIamPolicy_589267,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsTestIamPermissions_589286 = ref object of OpenApiRestCall_588441
proc url_CloudresourcemanagerOrganizationsTestIamPermissions_589288(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerOrganizationsTestIamPermissions_589287(
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
  var valid_589289 = path.getOrDefault("resource")
  valid_589289 = validateParameter(valid_589289, JString, required = true,
                                 default = nil)
  if valid_589289 != nil:
    section.add "resource", valid_589289
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
  var valid_589290 = query.getOrDefault("upload_protocol")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "upload_protocol", valid_589290
  var valid_589291 = query.getOrDefault("fields")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "fields", valid_589291
  var valid_589292 = query.getOrDefault("quotaUser")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "quotaUser", valid_589292
  var valid_589293 = query.getOrDefault("alt")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = newJString("json"))
  if valid_589293 != nil:
    section.add "alt", valid_589293
  var valid_589294 = query.getOrDefault("oauth_token")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "oauth_token", valid_589294
  var valid_589295 = query.getOrDefault("callback")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "callback", valid_589295
  var valid_589296 = query.getOrDefault("access_token")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "access_token", valid_589296
  var valid_589297 = query.getOrDefault("uploadType")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "uploadType", valid_589297
  var valid_589298 = query.getOrDefault("key")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "key", valid_589298
  var valid_589299 = query.getOrDefault("$.xgafv")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = newJString("1"))
  if valid_589299 != nil:
    section.add "$.xgafv", valid_589299
  var valid_589300 = query.getOrDefault("prettyPrint")
  valid_589300 = validateParameter(valid_589300, JBool, required = false,
                                 default = newJBool(true))
  if valid_589300 != nil:
    section.add "prettyPrint", valid_589300
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

proc call*(call_589302: Call_CloudresourcemanagerOrganizationsTestIamPermissions_589286;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Organization.
  ## The `resource` field should be the organization's resource name,
  ## e.g. "organizations/123".
  ## 
  let valid = call_589302.validator(path, query, header, formData, body)
  let scheme = call_589302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589302.url(scheme.get, call_589302.host, call_589302.base,
                         call_589302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589302, url, valid)

proc call*(call_589303: Call_CloudresourcemanagerOrganizationsTestIamPermissions_589286;
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
  var path_589304 = newJObject()
  var query_589305 = newJObject()
  var body_589306 = newJObject()
  add(query_589305, "upload_protocol", newJString(uploadProtocol))
  add(query_589305, "fields", newJString(fields))
  add(query_589305, "quotaUser", newJString(quotaUser))
  add(query_589305, "alt", newJString(alt))
  add(query_589305, "oauth_token", newJString(oauthToken))
  add(query_589305, "callback", newJString(callback))
  add(query_589305, "access_token", newJString(accessToken))
  add(query_589305, "uploadType", newJString(uploadType))
  add(query_589305, "key", newJString(key))
  add(query_589305, "$.xgafv", newJString(Xgafv))
  add(path_589304, "resource", newJString(resource))
  if body != nil:
    body_589306 = body
  add(query_589305, "prettyPrint", newJBool(prettyPrint))
  result = call_589303.call(path_589304, query_589305, nil, nil, body_589306)

var cloudresourcemanagerOrganizationsTestIamPermissions* = Call_CloudresourcemanagerOrganizationsTestIamPermissions_589286(
    name: "cloudresourcemanagerOrganizationsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions",
    validator: validate_CloudresourcemanagerOrganizationsTestIamPermissions_589287,
    base: "/", url: url_CloudresourcemanagerOrganizationsTestIamPermissions_589288,
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
