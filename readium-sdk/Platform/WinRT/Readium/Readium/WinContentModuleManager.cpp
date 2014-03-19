//
//  WinContentModuleManager.cpp
//  Readium
//
//  Created by Jim Dovey on 2013-11-01.
//  Copyright (c) 2012-2013 The Readium Foundation and contributors.
//  
//  The Readium SDK is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#include "WinContentModuleManager.h"
#include <ePub3/content_module_manager.h>
#include <ePub3/content_module.h>
#include "WinContainer.h"
#include "ExceptionWrapper.h"
#include "CollectionBridges.h"

#include <ppltasks.h>

using namespace ::Platform;
using namespace ::Windows::Foundation;

BEGIN_READIUM_API

void ContentModuleManager::RegisterContentModule(IContentModule^ module, String^ name)
{
	::ePub3::ContentModuleManager::Instance()->RegisterContentModule(std::make_shared<__WinRTContentModule>(module), StringToNative(name));
}

void ContentModuleManager::DisplayMessage(String^ title, String^ message)
{
	::ePub3::ContentModuleManager::Instance()->DisplayMessage(StringToNative(title), StringToNative(message));
}
IAsyncOperation<Credentials^>^ ContentModuleManager::RequestCredentialInput(CredentialRequest^ request)
{
	std::future<::ePub3::Credentials> future = ::ePub3::ContentModuleManager::Instance()->RequestCredentialInput(request->NativeObject);
	auto shared = future.share();

	return ::concurrency::create_async([shared]() -> Credentials^ {
		return ref new BridgedStringToStringMapView(shared.get());
	});
}

END_READIUM_API
